(* Copyright (C) 2024 okalm author(s)

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see {:https://www.gnu.org/licenses/}. *)

type hash = Sha256 | Sha512

(** Compute the big endian representatoin of an int [value] *)
let big_endian_int32 value =
  let shifters = [ 0; 8; 16; 24 ] in
  let anders = [ 0x000000FF; 0x0000FF00; 0x00FF0000; 0xFF000000 ] in
  let starter = [ value; value; value; value ] in
  let result =
    List.map2 Int.shift_left
      (List.map2 Int.shift_right (List.map2 Int.logand starter anders) shifters)
      (List.rev shifters)
  in
  Int.to_string @@ List.fold_left Int.logor 0 result

(** Compute the xor of two strings [s] and [v] *)
let xor s v =
  let len = String.length s in
  if len != String.length v then
    raise
      (Okcexn.OkcryptException "xored string arguments not of the same length")
  else
    let vb = Bytes.of_string v in
    let _ = Cryptokit.xor_string s 0 vb 0 len in
    Bytes.to_string vb

let rec f ?(tcat = "") ~prf ~salt ~xor_iterations ~tot_blocks blocki =
  let hashing u =
    let _ = prf#wipe in
    let _ = prf#add_string u in
    prf#result
  in
  let u1 = hashing (salt ^ big_endian_int32 blocki) in
  let rec xoring ?(xor_chained = "") previous_u = function
    | iter when iter = xor_iterations ->
        let u = hashing previous_u in
        xor xor_chained u
    | iter when iter = 1 ->
        let u = hashing previous_u in
        xoring ~xor_chained:previous_u u (iter + 1)
    | iter ->
        let u = hashing previous_u in
        xoring u ~xor_chained:(xor xor_chained u) (iter + 1)
  in
  let tblock = xoring u1 1 in
  if blocki = tot_blocks then tcat ^ tblock
  else
    f ~tcat:(tcat ^ tblock) ~prf ~salt ~xor_iterations ~tot_blocks (blocki + 1)

let pbkdf2 ?(xor_iterations = 1000) ?(keylen = 32) ?(hash = Sha256) ~salt s =
  let prf, hlen =
    match hash with
    | Sha256 ->
        let size = (Cryptokit.Hash.sha256 ())#hash_size in
        let prf = Cryptokit.MAC.hmac_sha256 s in
        (prf, size)
    | Sha512 ->
        let size = (Cryptokit.Hash.sha256 ())#hash_size in
        let prf = Cryptokit.MAC.hmac_sha256 s in
        (prf, size)
  in
  let tot_blocks = (keylen + hlen - 1) / hlen in
  f ~prf ~salt ~xor_iterations ~tot_blocks 1

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

let test_gen () =
  let module A = Alcotest in
  let module K = Okalm.Keys in
  let _, k2 = Okalm.Keys.gen "coconu" in
  A.(check string) "is a string" "onu" (Okalm.Keys.string_of_key k2)

let test_encrypt_key () =
  let module A = Alcotest in
  let module K = Okalm.Keys in
  let k1, _ = Okalm.Keys.gen "b8y0p84eqv52fg2gdzq4mc6zhfu8rg3w" in
  let res = Okalm.Keys.aes_encrypt_key k1 k1 "coconut" in
  A.(check string) "is a string" "\233iX\150\176=\\\255\029\\\203\\Twq\199" res

module Crypt = struct
  let test_encrypt () =
    let module A = Alcotest in
    let module K = Okalm.Keys in
    let k1, _ = Okalm.Keys.gen "b8y0p84eqv52fg2gdzq4mc6zhfu8rg3w" in
    let res =
      Okalm.Keys.Crypt.encrypt "content" k1 "coconut" Cryptokit.AEAD.Encrypt
    in
    A.(check string)
      "is a string" "\232>O\210\165k\028" res
end

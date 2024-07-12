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

(** Define PBKDF2 hash algorithm. *)

(** Type representing hashing. *)
type hash = Sha256 | Sha512

val big_endian_int32 : int -> string
(** [big_endian_int32 n] returns the big endian representation of the int [n]. *)

val pbkdf2 :
  ?xor_iterations:int ->
  ?keylen:int ->
  ?hash:hash ->
  salt:string ->
  string ->
  string
(** [pbkdf2 input] hash string input with PBKDF2, the output is base64 encoded. *)

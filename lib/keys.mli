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

(** Define utilities to split Pbkdf encrypted password. *)

type private_key
(** Define the type for non-storable/non-readable private key. *)

type public_key
(** Define the type for storable/readable key. *)

val string_of_key : public_key -> string
(** Return the key formatted into a string. *)

val gen : string -> private_key * public_key
(** [split key] split the [key] in both half and returns the
    tuple containing the two keys, the keylength must be even. *)

val rand : int -> private_key
(** [rand 32] generate a random key of 256 bits length. *)

val aes_encrypt_key : private_key -> private_key -> string -> string
(** [aes_encrypt_key k1 key iv] encrypt key [k1] with [key] given an initial
   vector [iv] with AES, and returns the encrypted string. *)

val aes_decrypt_key : string -> private_key -> string -> private_key
(** [aes_decrypt_key encrypted key iv] decrypt [encrypted] with [key] given the initial vector [iv]
   with AES, and returns the decrypted key. *)

module Crypt : sig
  (** Encrypt with keys *)

  val encrypt :
    string -> private_key -> string -> Cryptokit.AEAD.direction -> string
  (** [encrypt content key iv] encrypt the [content] with the given
      [key] and initial vector [iv]. *)
end

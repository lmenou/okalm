(** Define utilities to work with keys *)

type private_key = Private of string
type public_key = Public of string

let string_of_key = function Public value -> value

(** Get the value out of a private_key *)
let private_key_to_string = function Private value -> value

let gen value =
  let length = String.length value / 2 in
  let second = Private (String.sub value 0 length) in
  let third = Public (String.sub value length length) in
  (second, third)

let rand value = Private (Rgen.random_string value)

let aes_encrypt_key to_encrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (private_key_to_string key) Encrypt in
  let _ = aest#put_string (private_key_to_string to_encrypt) in
  let _ = aest#finish_and_get_tag in
  aest#get_string

let aes_decrypt_key to_decrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (private_key_to_string key) Decrypt in
  let _ = aest#put_string to_decrypt in
  let _ = aest#finish_and_get_tag in
  Private aest#get_string

module Crypt : sig
  val encrypt : string -> private_key -> string -> Cryptokit.AEAD.direction -> string
end = struct
  let encrypt content key iv direction =
    let aest = Cryptokit.AEAD.aes_gcm ~iv (private_key_to_string key) direction in
    let _ = aest#put_string content in
    let _ = aest#finish_and_get_tag in
    aest#get_string
end

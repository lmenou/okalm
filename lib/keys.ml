(** Define utilities to work with keys *)

(** NOTE(lmenou): Define more types Encrypted Keys, PublicKeys and PrivateKeys,
    this would enable type checking restriction on the storage **)

type key = Key of string

let string_of_key = function Key value -> value

let gen value =
  let length = String.length value / 2 in
  let second = Key (String.sub value 0 length) in
  let third = Key (String.sub value length length) in
  (second, third)

let rand value = Key (Rgen.random_string value)

let aes_encrypt_key to_encrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (string_of_key key) Encrypt in
  let _ = aest#put_string (string_of_key to_encrypt) in
  let _ = aest#finish_and_get_tag in
  aest#get_string

let aes_decrypt_key to_decrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (string_of_key key) Decrypt in
  let _ = aest#put_string to_decrypt in
  let _ = aest#finish_and_get_tag in
  Key aest#get_string

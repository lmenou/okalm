(** Define utilities to work with keys *)

(** NOTE(lmenou): Define more types Encrypted Keys, PublicKeys and PrivateKeys,
    this would enable type checking restriction on the storage **)

type private_key = Private of string
type public_key = Public of string
type encrypted_key = Encrypted of string
type key = EncryptedKey of encrypted_key | PubKey of public_key

let string_of_key = function
  | PubKey (Public value) -> value
  | EncryptedKey (Encrypted value) -> value

(** Get the value out of a private_key *)
let private_key_to_string = function Private value -> value

let gen value =
  let length = String.length value / 2 in
  let second = Private (String.sub value 0 length) in
  let third = PubKey (Public (String.sub value length length)) in
  (second, third)

let rand value = Private (Rgen.random_string value)

let aes_encrypt_key to_encrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (private_key_to_string key) Encrypt in
  let _ = aest#put_string (private_key_to_string to_encrypt) in
  let _ = aest#finish_and_get_tag in
  EncryptedKey (Encrypted aest#get_string)

let aes_decrypt_key to_decrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (private_key_to_string key) Decrypt in
  let _ = aest#put_string (string_of_key to_decrypt) in
  let _ = aest#finish_and_get_tag in
  Private aest#get_string

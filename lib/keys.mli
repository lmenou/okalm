(** Define utilities to split Pbkdf encrypted password *)

type key
(** Type defining keys *)

val string_of_key : key -> string

val gen : string -> key * key
(** [split key] split the encrypted password in both half and returns the
    tuple containing the two keys, the keylenght must be even *)

val rand : int -> key
(** [rand 32] generate a random key of 256 bits length *)

val aes_encrypt_key : key -> key -> string -> string
(* [aes_encrypt_key k1 key iv] encrypt key [k1] with [key] given an initial
   vector [iv] with AES, and returns the encrypted string *)

val aes_decrypt_key : string -> key -> string -> key
(* [aes_decrypt_key encrypted key iv] decrypt [encrypted] with [key] given the initial vector [iv]
   with AES, and returns the decrypted key *)

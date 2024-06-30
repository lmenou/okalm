(** Define utilities to split Pbkdf encrypted password *)

type private_key
(** Define the type for non-storable/non-readable private key *)

type key
(** Define the type for storable/readable key *)

(** Return the key formatted into a string *)
val string_of_key : key -> string

val gen : string -> private_key * key
(** [split key] split the [key] in both half and returns the
    tuple containing the two keys, the keylength must be even *)

val rand : int -> private_key
(** [rand 32] generate a random key of 256 bits length *)

val aes_encrypt_key : private_key -> private_key -> string -> key
(* [aes_encrypt_key k1 key iv] encrypt key [k1] with [key] given an initial
   vector [iv] with AES, and returns the encrypted string *)

val aes_decrypt_key : key -> private_key -> string -> private_key
(* [aes_decrypt_key encrypted key iv] decrypt [encrypted] with [key] given the initial vector [iv]
   with AES, and returns the decrypted key *)

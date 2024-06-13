(** Module generating a random key for the encryption *)

type salt = Salt of bytes | Null
(** Define the type of key *)

module SaltStore : Store.Storage
(** Name of the file in the store *)

val string_of_key : salt -> string
(** Return the key as a string *)

val get : unit -> salt
(** Generate the random byte sequence as the key, the key is composed of ASCII
    character only and is of size 256 bits  *)

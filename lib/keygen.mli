(** Module generating a random key for the encryption *)

type key
(** Define the type of key *)

module KeyStore : Store.Storage
(** Name of the file in the store *)

val string_of_key : key -> string
(** Return the key as a string *)

val get : unit -> key
(** Generate the random byte sequence as the key, the key is composed of ASCII
    character only and is of size 256 bits  *)

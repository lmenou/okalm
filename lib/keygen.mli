(** Module generating a random key for the encryption *)

val get : unit -> bytes
(** Generate the random byte sequence as the key, the key is composed of ASCII
    character only and is of size 256 bits  *)

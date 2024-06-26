(** Define utilities to encrypt or decrypt files *)

val crypt : string -> Keys.key -> string -> unit
(** [encrypt file key iv] encrypt the file, progressively if necessary *)

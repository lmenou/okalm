(** Define utilities to encrypt or decrypt files *)

val crypt : string -> Keys.key -> string -> unit
(** [encrypt file key iv] encrypt the content of the [file] with the given
      [key] and initial vector [iv] *)

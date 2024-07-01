(** Module defining utilities to store the cryptographic keys used to
    encrypt files and folders *)

val store : string -> string -> unit
val exist : string -> bool
val unstore : string -> string

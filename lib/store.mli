(** Module defining utilities to store the cryptographic keys used to
    encrypt files and folders *)

type t = Key of Keys.key | Stock of string

val store : string list -> t list -> unit list
val exist : string -> bool
val unstore : string -> string

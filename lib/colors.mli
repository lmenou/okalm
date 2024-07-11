type t

val make : string -> t
val set_tty_color : t -> string
val reset_tty : unit -> string

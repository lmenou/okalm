(** Define utilities for password management *)

type password
(** Define password type *)

val getpass : prompt_message:string -> password
(** Get the user password without printing on the terminal. This is done by
    setting the echo attribute to false on the tty itself. *)

val exist : unit -> bool
(** Check if a password exist in the store or not *)

val store : string -> unit
(** Store the password *)

val unstore : unit -> string
(** Unstore the password *)

val string_of_password : password -> string
(** Return the string of the password *)

val getpass : prompt_message:string -> string
(** Get the user password without printing on the terminal. This is done by
    setting the echo attribute to false on the tty itself. *)

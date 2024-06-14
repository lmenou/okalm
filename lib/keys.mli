(** Define utilities to split Pbkdf encrypted password *)

type key
(** Type defining keys *)

val string_of_key : key -> string

val gen : string -> key * key * key
(** [split key] split the encrypted password in both half and returns the
    tuple containing the two keys, the keylenght must be even *)

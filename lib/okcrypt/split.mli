(** Define utilities to split Pbkdf encrypted key *)

(** [split key] split the key in both half, the keylenght must be even *)
val split : Pbkdf.key -> Pbkdf.key * Pbkdf.key

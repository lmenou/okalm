val create : unit -> string ref
val is_empty : string ref -> bool
val add_char : string ref -> char -> unit

val rm_last_char : string ref -> unit
val get : 'a ref -> 'a

val reset : string ref -> unit

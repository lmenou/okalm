(** Define PBKDF2 hash algorithm *)

(** Type representing hashing *)
type hash = Sha256 | Sha512

val big_endian_int32 : int -> string
(** [big_endian_int32 n] returns the big endian representation of the int [n] *)

val pbkdf2 :
  ?xor_iterations:int ->
  ?keylen:int ->
  ?hash:hash ->
  salt:string ->
  string ->
  string
(** [pbkdf2 input] hash string input with PBKDF2, the output is base64 encoded *)

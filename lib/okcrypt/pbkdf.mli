(** Define PBKDF2 hash algorithm *)

type hash = Sha256 | Sha512  (** Type representing hashing *)

val pbkdf2 :
  ?xor_iterations:int ->
  ?keylen:int ->
  ?hash:hash ->
  salt:string ->
  string ->
  string
(** [pbkdf2 input] hash string input with PBKDF2, the output is base64 encoded *)

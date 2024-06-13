(** Define PBKDF2 hash algorithm *)

type hash = Sha256 | Sha512  (** Type representing hashing *)

type key = Key of string | Null (** Key type representation *)

val pbkdf2 :
  ?xor_iterations:int ->
  ?keylen:int ->
  ?hash:hash ->
  salt:string ->
  string ->
  key
(** [pbkdf2 input] hash string input with PBKDF2, the output is base64 encoded *)

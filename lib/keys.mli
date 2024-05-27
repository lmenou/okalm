(** Module defining utilities to manage the cryptographic keys used to
    encrypt files and folders *)

val use : password:string -> unit
(** Use the password to generate default cryptographic keys *)

(** Module used to retrieve an $XDG_DATA_HOME/okalm folder for private data
    storage and configuration *)
module OkalmDataHome : sig
  val get : unit -> string
  (** Return the expanded $XDG_DATA_HOME/okalm *)
end

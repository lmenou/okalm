(** Module defining utilities to store the cryptographic keys used to
    encrypt files and folders *)

(** Interface required to create a Storer *)
module type Storage = sig
  val filename : string
end

(** Interface of the output of the functor Make *)
module type Storer = sig
  val store : string -> unit
  val unstore : unit -> string
  val exist : unit -> bool
end

(** Define the functor itself *)
module Make (_ : Storage) : Storer

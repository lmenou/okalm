module OkalmDataHome : sig
  (** Module used to retrieve an $XDG_DATA_HOME/okalm folder for private data
    storage and configuration *)

  val get : unit -> string
  (** Return the expanded $XDG_DATA_HOME/okalm *)
end = struct
  let standard_location =
    try
      let home = Sys.getenv "HOME" in
      let module F = Filename in
      let rec concat folders =
        match folders with [] -> "" | hd :: tl -> F.concat hd (concat tl)
      in
      let no_user_error =
        Exn.OkalmExn "Not in a standard user environment, aborting"
      in
      let standard = concat [ home; ".local"; "share" ] in
      try
        if Sys.is_directory standard then F.concat standard "okalm"
        else raise no_user_error
      with Sys_error _ -> raise no_user_error
    with Not_found -> raise (Exn.OkalmExn "No $HOME, aborting")

  let okalm_data_home =
    try
      let config = Sys.getenv "XDG_DATA_HOME" in
      let module F = Filename in
      F.concat config "okalm"
    with Not_found -> standard_location

  let get () =
    try
      if Sys.is_directory okalm_data_home then okalm_data_home
      else
        raise
          (Exn.OkalmExn "No okalm directory in $XDG_DATA_HOME, aborting")
    with Sys_error _ ->
      Unix.mkdir okalm_data_home 0o700;
      okalm_data_home
end

module type Storage = sig
  val filename : string
end

module type Storer = sig
  val store : string -> unit
  val unstore : unit -> string
  val exist : unit -> bool
end

module Make (S : Storage) : Storer = struct
  let store elem =
    let module O = Out_channel in
    let module F = Filename in
    let dest = OkalmDataHome.get () in
    let write filename text =
      O.with_open_text (F.concat dest filename) (fun oc ->
          output_string oc text)
    in
    write S.filename elem

  let exist () =
    let module F = Filename in
    let dest = OkalmDataHome.get () in
    let filename = S.filename in
    try
      let result = Sys.is_regular_file (F.concat dest filename) in
      result
    with Sys_error _ -> false

  let unstore () =
    let module I = In_channel in
    let module F = Filename in
    let dest = OkalmDataHome.get () in
    let read filename = I.with_open_text (F.concat dest filename) input_line in
    read S.filename
end

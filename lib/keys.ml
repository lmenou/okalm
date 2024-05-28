module OkalmDataHome : sig
  val get : unit -> string
end = struct
  let standard_location =
    try
      let home = Sys.getenv "HOME" in
      let module F = Filename in
      let rec concat folders =
        match folders with [] -> "" | hd :: tl -> F.concat hd (concat tl)
      in
      let no_user_error =
        Errors.OkalmError "Not in a standard user environment, aborting"
      in
      let standard = concat [ home; ".local"; "share" ] in
      try
        if Sys.is_directory standard then F.concat standard "okalm"
        else raise no_user_error
      with Sys_error _ -> raise no_user_error
    with Not_found -> raise (Errors.OkalmError "No $HOME, aborting")

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
          (Errors.OkalmError "No okalm directory in $XDG_DATA_HOME, aborting")
    with Sys_error _ ->
      Unix.mkdir okalm_data_home 0o700;
      okalm_data_home
end

module OkalmPassFile : sig
  val store : filepath:string -> text:string -> unit
end = struct
  let store ~filepath ~text =
    let module O = Out_channel in
    let module F = Filename in
    O.with_open_text (F.concat filepath "keypass") (fun oc ->
        output_string oc text)
end

let make_double_hash ~password =
  let module B = Bcrypt in
  let hash text = B.string_of_hash @@ B.hash text in
  let rec hash_twice ?(times = 2) pass =
    if times = 0 then pass else hash_twice ~times:(times - 1) (hash pass)
  in
  hash_twice password

let use ~password =
  let home = OkalmDataHome.get () in
  let hash = make_double_hash ~password in
  OkalmPassFile.store ~filepath:home ~text:hash

module Utils : sig
  exception OkalmError of string

  val make_data_home : unit -> unit
end = struct
  exception OkalmError of string

  let xdg_config_data env_variable =
    let module F = Filename in
    match env_variable with
    | Some data_dir -> F.concat data_dir "okalm"
    | None ->
        let home = Sys.getenv "HOME" in
        let root =
          let rec concat folders =
            match folders with [] -> "" | hd :: tl -> F.concat hd (concat tl)
          in
          concat [ home; ".local"; "share" ]
        in
        if Sys.is_directory root then F.concat root "okalm"
        else raise (OkalmError "cli is not used by a standard user")

  let make_data_home () =
    let path =
      try Sys.getenv "XDG_DATA_HOME" with
      | Not_found -> xdg_config_data None
      | _ -> xdg_config_data (Some (Sys.getenv "XDG_DATA_HOME"))
    in
    try
      if Sys.is_directory path then ()
      else raise (OkalmError "$XDG_DATA_HOME/okalm is not a directory?")
    with Sys_error _ -> Unix.mkdir path 0o700
end

let use pass =
  print_endline pass;
  Utils.make_data_home ()

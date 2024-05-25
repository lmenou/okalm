let is_host_windows () =
  match Sys.os_type with
  | "Win32" ->
      print_endline
        "Warning: the CLI is not tested on Windows, you may experience violent \
         bugs; hence aborting cowardly";
      true
  | _ -> false

let crypter file =
  if is_host_windows () then () else print_endline file;
  let pass = Getpass.getpass ~prompt_message:"Please enter your password:" in
  Keys.use pass

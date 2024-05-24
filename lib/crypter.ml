let is_host_windows () =
  match Sys.os_type with
  | "Win32" ->
      print_endline
        "Warning: the CLI is not battery tested on Windows, you may experience \
         violent bugs, aborting cowardly";
      true
  | _ -> false

let crypter file =
  match is_host_windows () with
  | true -> ()
  | false ->
      print_endline file;
      let pass = Getpass.getpass "Please enter your password:" in
      print_endline pass;
      let hash = Bcrypt.hash pass in
      hash |> Bcrypt.string_of_hash |> print_endline

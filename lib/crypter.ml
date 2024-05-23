let crypter file =
  print_endline file;
  let pass = Getpass.getpass "Please enter your password:" in
  print_endline pass;
  let hash = Bcrypt.hash pass in
  hash |> Bcrypt.string_of_hash |> print_endline

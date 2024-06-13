let crypter file =
  if Sys.win32 || Sys.cygwin then
    print_endline
      "Warning: the CLI is not tested on Windows, you may experience violent  \
       bugs; hence aborting cowardly"
  else
    let _ = print_endline file in
    let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
    let salt = Keygen.get () in
    let key =
      Okcrypt.Pbkdf.pbkdf2
        ~salt:(Keygen.string_of_key salt)
        ~keylen:32 ~hash:Sha256
        (Pass.string_of_password pass)
    in
    let k1, _ = Okcrypt.Split.split key in
    match k1 with
    | Okcrypt.Pbkdf.Key value -> print_endline value
    | Okcrypt.Pbkdf.Null -> ()

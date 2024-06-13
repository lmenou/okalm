let crypter file =
  if Sys.win32 || Sys.cygwin then
    print_endline
      "Warning: the CLI is not tested on Windows, you may experience violent  \
       bugs; hence aborting cowardly"
  else
    let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
    if Pass.exist () then
      let _ = print_endline file in
      let res =
        Okcrypt.Pbkdf.pbkdf2 ~salt:"coucou" ~keylen:32 ~hash:Sha256
          (Pass.string_of_password pass)
      in
      print_endline res
    else Pass.(store (string_of_password pass))

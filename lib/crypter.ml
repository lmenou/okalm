let crypter file =
  if Sys.win32 || Sys.cygwin then
    print_endline
      "Warning: the CLI is not tested on Windows, you may experience violent  \
       bugs; hence aborting cowardly"
  else
    let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
    if Pass.exist () then print_endline file
    else Pass.(store (string_of_password pass))

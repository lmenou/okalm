open Cmdliner

let crypter file = Printf.printf "%s\n" file
let file = Arg.(required & pos 0 (some file) None & info [] ~docv:"FILE")

let cmd =
  let doc = "Encrypt files or directories" in
  let man =
    [
      `S Manpage.s_description;
      `P
        "$(tname) encrypt each specified $(i,FILE). By default it does not\n\
         encrypt directories, to also encrypt them and their contents, use the\n\
         option $(b,--recursive) ($(b,-r) or $(b,-R)).";
    ]
  in
  let info = Cmd.info "okalm" ~version:"%%VERSION%%" ~doc ~man in
  Cmd.v info Term.(const crypter $ file)

let main () = exit (Cmd.eval cmd)
let () = main ()

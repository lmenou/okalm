(* Copyright (C) 2024 okalm author(s)

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see {:https://www.gnu.org/licenses/}. *)

open Cmdliner

let pass =
  let option =
    let verify =
      let doc =
        "($(b,DEFAULT)) Verify the encrypted password for the encryption. You \
         must run the command with the option $(b,--init) at least once on \
         first use."
      in
      (Okalm.Crypter.Verify, Arg.info [ "verify" ] ~doc)
    in
    let init =
      let doc =
        "Initialize and store the encrypted password for the encryption. You \
         must run the command at least once on first use."
      in
      (Okalm.Crypter.Initiate, Arg.info [ "init" ] ~doc)
    in
    let change =
      let doc =
        "Change and store the encrypted password for the encryption. You must \
         run the command with the option $(b,--init) at least once on first \
         use."
      in
      (Okalm.Crypter.Change, Arg.info [ "change" ] ~doc)
    in
    Arg.(value & vflag Okalm.Crypter.Verify [ verify; init; change ])
  in
  let doc = "Manage password in the broad sense." in
  let man =
    [
      `S Manpage.s_description;
      `P
        "Manage password, to change it or to verify it. Options are mutually \
         exclusive.";
    ]
  in
  let info = Cmd.info "pass" ~doc ~man in
  Cmd.v info Term.(map Okalm.Crypter.pass option)

let encrypt =
  let file =
    let doc = "The file to encrypt." in
    Arg.(required & pos 0 (some file) None & info [] ~doc ~docv:"FILE")
  in
  let doc = "Encrypt the provided file." in
  let man =
    [
      `S Manpage.s_description;
      `P "Encrypt the provided file. Only pure text files are managed so far.";
    ]
  in
  let info = Cmd.info "encrypt" ~doc ~man in
  Cmd.v info Term.(const Okalm.Crypter.encrypt $ file)

let cmd =
  let doc = "Encrypt files, on the command line the ML way." in
  let man =
    [
      `S Manpage.s_description;
      `P
        "$(tname) encrypt the specified $(i,FILE). It does not\n\
         encrypt directories, (yet?).";
    ]
  in
  let info = Cmd.info "okalm" ~version:"%%VERSION%%" ~doc ~man in
  Cmd.group info [ pass; encrypt ]

let () = exit (Cmd.eval cmd)

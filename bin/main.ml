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

let file = Arg.(required & pos 0 (some file) None & info [] ~docv:"FILE")

let checkpass =
  let change =
    let doc = "Change your password." in
    (Okalm.Crypter.Change, Arg.info [ "c"; "change" ] ~doc)
  in
  let verify =
    let doc = "Simply check your password." in
    (Okalm.Crypter.Verify, Arg.info [ "v"; "verify" ] ~doc)
  in
  let verify_and_encrypt =
    let doc = "Check your password and encrypt the given file (default)." in
    (Okalm.Crypter.VerifyAndEncrypt, Arg.info [ "e"; "verify-and-encrypt" ] ~doc)
  in
  Arg.(
    last
    & vflag_all
        [ Okalm.Crypter.VerifyAndEncrypt ]
        [ change; verify; verify_and_encrypt ])

let cmd =
  let doc = "Encrypt files" in
  let man =
    [
      `S Manpage.s_description;
      `P
        "$(tname) encrypt each specified $(i,FILE). It does not\n\
         encrypt directories, (yet?).";
    ]
  in
  let info = Cmd.info "okalm" ~version:"%%VERSION%%" ~doc ~man in
  Cmd.v info Term.(const Okalm.Crypter.crypter $ checkpass $ file)

let main () = exit (Cmd.eval cmd)
let () = main ()

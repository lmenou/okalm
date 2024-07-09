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

type opt = Change | Verify | VerifyAndEncrypt

(** Generate and store keys *)
let setup () =
  let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
  let salt = Rgen.random_string 32 in
  let iv = Rgen.random_string 32 in
  let encrypted_password =
    Okcrypt.Pbkdf.pbkdf2 ~salt (Pass.string_of_password pass)
  in
  let k2, k3 = Keys.gen encrypted_password in
  let k1 = Keys.rand 32 in
  let k1e = Keys.aes_encrypt_key k1 k2 iv in
  let filenames = [ "k1e"; "k3"; "salt"; "iv" ] in
  let elems = [ k1e; Keys.string_of_key k3; salt; iv ] in
  let _ = List.map2 Store.store filenames elems in
  (k1, iv)

(** Decrypt keys from the storage *)
let decryption () =
  let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
  let salt = Store.unstore "salt" in
  let iv = Store.unstore "iv" in
  let encrypted_password =
    Okcrypt.Pbkdf.pbkdf2 ~salt (Pass.string_of_password pass)
  in
  let k2, k3 = Keys.gen encrypted_password in
  let k3s = Store.unstore "k3" in
  if String.equal (Keys.string_of_key k3) k3s then
    let k1e = Store.unstore "k1e" in
    let k1 = Keys.aes_decrypt_key k1e k2 iv in
    (k1, iv)
  else
    let _ =
      Printf.eprintf "%s"
        "Problem: Your password may be wrong or someone tampered with your \
         files!\n\
         Stopping here.\n"
    in
    raise (Exn.OkalmExn "Could not decrypt the first key for file decryption.")

let crypter passoption file =
  if Sys.win32 || Sys.cygwin then
    Printf.eprintf "%s"
      "Warning: the CLI is not tested on Windows, you may experience violent\n\
       bugs; hence aborting cowardly.\n"
  else if not (Store.exist "iv") then
    match passoption with
    | Verify ->
        Printf.eprintf "%s"
          "Problem: Cannot verify your password, store is empty!\n\
           Stopping here.\n"
    | Change ->
        Printf.eprintf "%s"
          "Problem: Cannot change your password, store is empty!\n\
           Stopping here.\n"
    | VerifyAndEncrypt -> (
        match file with
        | Some value ->
            let k1, iv = setup () in
            Encwrite.crypt value k1 iv
        | None -> print_endline "not implemented yet")
  else
    match passoption with
    | Verify -> (
        try
          ignore (decryption ());
          print_endline "Everything is fine!"
        with Exn.OkalmExn value -> print_endline value)
    | Change -> (
        match file with
        | Some value ->
            let k1, iv = setup () in
            Encwrite.crypt value k1 iv
        | None -> print_endline "not implemented yet")
    | VerifyAndEncrypt -> (
        match file with
        | Some value -> (
            try
              let k1, iv = decryption () in
              Encwrite.crypt value k1 iv
            with Exn.OkalmExn value -> print_endline value)
        | None -> print_endline "not implemented")

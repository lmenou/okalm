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

let pp_error main explain =
  let okalm =
    Tty.Style.write_with ~sty:[ Tty.Style.Bold ] (`ANSI256 1) "okalm: "
  in
  let usage = "\nTry 'okalm --help' for more information.\n" in
  let main =
    Tty.Style.write_with ~sty:[ Tty.Style.Underline ] (`ANSI256 0) (main ^ ":")
  in
  Printf.eprintf "%s" (okalm ^ main ^ " " ^ explain ^ usage)

let pp_success main explain =
  let okalm =
    Tty.Style.write_with ~sty:[ Tty.Style.Bold ] (`ANSI256 1) "okalm: "
  in
  let main =
    Tty.Style.write_with
      ~sty:[ Tty.Style.Bold; Tty.Style.Italic ]
      (`ANSI256 4) (main ^ ":")
  in
  Printf.printf "%s" (okalm ^ main ^ " " ^ explain ^ "\n")

type passopt = Verify | Change | Initiate

(** Generate and store keys *)
let setup () =
  let pass = Tty.Pass.getpass ~prompt_message:"Please enter your password:" in
  let salt = Rgen.random_string 32 in
  let iv = Rgen.random_string 32 in
  let encrypted_password =
    Okcrypt.Pbkdf.pbkdf2 ~salt (Tty.Pass.string_of_password pass)
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
  let pass = Tty.Pass.getpass ~prompt_message:"Please enter your password:" in
  let salt = Store.unstore "salt" in
  let iv = Store.unstore "iv" in
  let encrypted_password =
    Okcrypt.Pbkdf.pbkdf2 ~salt (Tty.Pass.string_of_password pass)
  in
  let k2, k3 = Keys.gen encrypted_password in
  let k3s = Store.unstore "k3" in
  if String.equal (Keys.string_of_key k3) k3s then
    let k1e = Store.unstore "k1e" in
    let k1 = Keys.aes_decrypt_key k1e k2 iv in
    (k1, iv)
  else
    raise
      (Exn.OkalmExn
         "Could not decrypt the first key for file decryption.\n\n\
          Either password is wrong or someone tampered with your files!\n")

let pass option =
  match option with
  | Verify -> (
      if not Store.filled then
        let _ =
          pp_error "PASSWORD command"
            "cannot verify, on first run, use --init options."
        in
        ()
      else
        try
          let _ = decryption () in
          pp_success "PASSWORD verification" "everything ok!"
        with Exn.OkalmExn value -> pp_error "PASSWORD error" value)
  | Change -> (
      if not Store.filled then
        let _ =
          pp_error "PASSWORD command"
            "cannot verify, on first run, use --init options."
        in
        ()
      else
        try
          let _ = setup () in
          pp_success "PASSWORD change" "change ok!"
        with Exn.OkalmExn value -> pp_error "PASSWORD error" value)
  | Initiate -> (
      if Store.filled then
        let _ =
          pp_error "PASSWORD command"
            "cannot init, second run, use other options."
        in
        ()
      else
        try
          let _ = setup () in
          pp_success "PASSWORD command" "init ok!"
        with Exn.OkalmExn value -> pp_error "PASSWORD error" value)

let encrypt file =
  try
    let k1, iv = decryption () in
    Encwrite.crypt file k1 iv
  with Exn.OkalmExn value -> pp_error "PASSWORD error" value

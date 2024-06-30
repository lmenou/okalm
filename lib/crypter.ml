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
  let _ =
    Store.store
      [ "k1e"; "k3"; "salt"; "iv" ]
      [ Store.Key k1e; Store.Key k3; Store.Stock salt; Store.Stock iv ]
  in
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

let crypter file =
  if Sys.win32 || Sys.cygwin then
    Printf.eprintf "%s"
      "Warning: the CLI is not tested on Windows, you may experience violent\n\
       bugs; hence aborting cowardly.\n"
  else if not (Store.exist "iv") then
    let k1, iv = setup () in
    Encwrite.crypt file k1 iv
  else
    try
      let k1, iv = decryption () in
      Encwrite.crypt file k1 iv
    with Exn.OkalmExn value -> print_endline value

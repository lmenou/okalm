let encrypt_k1 to_encrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv key Encrypt in
  let _ = aest#put_string to_encrypt in
  let _ = aest#finish_and_get_tag in
  aest#get_string

let decrypt_k1 to_decrypt key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv key Decrypt in
  let _ = aest#put_string to_decrypt in
  let _ = aest#finish_and_get_tag in
  aest#get_string

let setup () =
  let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
  let salt = Rgen.random_string 32 in
  let iv = Rgen.random_string 32 in
  let encrypted_password =
    Okcrypt.Pbkdf.pbkdf2 ~salt (Pass.string_of_password pass)
  in
  let k1, k2, k3 = Keys.gen encrypted_password in
  let k1s = encrypt_k1 (Keys.string_of_key k1) (Keys.string_of_key k2) iv in
  let _ =
    List.map2 Store.store
      [ "k1s"; "k3"; "salt"; "iv" ]
      [ k1s; Keys.string_of_key k3; salt; iv ]
  in
  ()

let decryption () =
  let pass = Pass.getpass ~prompt_message:"Please enter your password:" in
  let salt = Store.unstore "salt" in
  let iv = Store.unstore "iv" in
  let encrypted_password =
    Okcrypt.Pbkdf.pbkdf2 ~salt (Pass.string_of_password pass)
  in
  let _, k2, k3 = Keys.gen encrypted_password in
  let k3s = Store.unstore "k3" in
  if String.equal (Keys.string_of_key k3) k3s then
    let k1s = Store.unstore "k1s" in
    let k1 = decrypt_k1 k1s (Keys.string_of_key k2) iv in
    print_endline k1
  else
    Printf.eprintf "%s"
      "Problem: Your password may be wrong or someone tampered with your files!\n\
       Stopping here.\n"

let crypter file =
  let filesize = (Unix.LargeFile.stat file).st_size in
  let _ = print_endline (Int64.to_string filesize) in
  if Sys.win32 || Sys.cygwin then
    Printf.eprintf "%s"
      "Warning: the CLI is not tested on Windows, you may experience violent\n\
       bugs; hence aborting cowardly.\n"
  else if not (Store.exist "iv") then setup ()
  else decryption ()

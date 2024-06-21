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
      [ "k1s"; "k3"; "salt"; "iv" ]
      [ Store.Stock k1e; Store.Key k3; Store.Stock salt; Store.Stock iv ]
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
    let k1s = Store.unstore "k1s" in
    let k1 = Keys.aes_decrypt_key k1s k2 iv in
    (k1, iv)
  else
    let _ =
      Printf.eprintf "%s"
        "Problem: Your password may be wrong or someone tampered with your \
         files!\n\
         Stopping here.\n"
    in
    raise (Exn.OkalmExn "Could not decrypt the first key for file decryption.")

let write filename content =
  let module O = Out_channel in
  O.with_open_text filename (fun oc -> output_string oc content)

let read filename =
  let module I = In_channel in
  I.with_open_text filename input_line

let encrypt file key iv =
  let filesize = (Unix.LargeFile.stat file).st_size in
  if filesize > Int64.of_int 70 then print_endline "not now"
  else
    let to_encrypt = read file in
    let aest = Cryptokit.AEAD.aes_gcm ~iv (Keys.string_of_key key) Encrypt in
    let _ = aest#put_string to_encrypt in
    let _ = aest#finish_and_get_tag in
    write file aest#get_string

(* Main function *)
let crypter file =
  let filesize = (Unix.LargeFile.stat file).st_size in
  let _ = print_endline (Int64.to_string filesize) in
  if Sys.win32 || Sys.cygwin then
    Printf.eprintf "%s"
      "Warning: the CLI is not tested on Windows, you may experience violent\n\
       bugs; hence aborting cowardly.\n"
  else if not (Store.exist "iv") then
    let k1, iv = setup () in
    encrypt file k1 iv
  else
    try
      let k1, iv = decryption () in
      encrypt file k1 iv
    with Exn.OkalmExn value -> print_endline value

let write filename content =
  let module O = Out_channel in
  O.with_open_text filename (fun oc -> output_string oc content)

let read filename =
  let module I = In_channel in
  I.with_open_text filename input_line

let crypt file key iv =
  let filesize = (Unix.LargeFile.stat file).st_size in
  if filesize > Int64.of_int 70 then print_endline "not now"
  else
    let to_encrypt = read file in
    let aest = Cryptokit.AEAD.aes_gcm ~iv (Keys.string_of_key key) Encrypt in
    let _ = aest#put_string to_encrypt in
    let _ = aest#finish_and_get_tag in
    write file aest#get_string

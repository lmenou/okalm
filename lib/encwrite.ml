(** [write file content] overwrite [content] in [file] *)
let write filename content =
  let module O = Out_channel in
  O.with_open_text filename (fun oc -> output_string oc content)

(** [read file] returns the [content] in [file] *)
let read filename =
  let module I = In_channel in
  I.with_open_text filename input_line

(** Encryption unit generator, [encrypt content key iv] encrypt the [content]
provided with the [key] and initial vector [iv] *)
let encrypt content key iv =
  let aest = Cryptokit.AEAD.aes_gcm ~iv (Keys.string_of_key key) Encrypt in
  let _ = aest#put_string content in
  let _ = aest#finish_and_get_tag in
  aest#get_string

let crypt file key iv =
  let filesize = (Unix.LargeFile.stat file).st_size in
  if filesize > Int64.of_int 70 then print_endline "not now"
  else
    let content = read file in
    let result = encrypt content key iv in
    write file result

let step = 70
let max_size = Int64.of_int step

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

let encryptf file key iv =
  let module I = In_channel in
  let module O = Out_channel in
  let rec crypting ic oc key iv pos =
    let filesize = (Unix.LargeFile.stat file).st_size in
    if Int64.add pos max_size >= filesize then
      let maxb = Int64.to_int @@ Int64.sub filesize pos in
      let _ = I.seek ic pos in
      let buffer = Bytes.create maxb in
      let _ = I.input ic buffer 0 maxb in
      let to_write = encrypt (Bytes.to_string buffer) key iv in
      let _ = O.output_string oc to_write in
      let _ = I.close ic in
      O.close oc
    else
      let buffer = Bytes.create step in
      let _ = I.seek ic pos in
      let _ = I.input ic buffer 0 step in
      let to_write = encrypt (Bytes.to_string buffer) key iv in
      let _ = O.output_string oc to_write in
      crypting ic oc key iv (Int64.add pos max_size)
  in
  let ic = I.open_bin file in
  let oc = O.open_gen [ Open_creat; Open_append ] 0o644 "coucou" in
  crypting ic oc key iv (Int64.of_int 0)

let crypt file key iv =
  let filesize = (Unix.LargeFile.stat file).st_size in
  if filesize > max_size then encryptf file key iv
  else
    let content = read file in
    let result = encrypt content key iv in
    write file result

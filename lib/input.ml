let create () = ref ""
let is_empty t = !t = ""
let add_char t chr = t := !t ^ Char.escaped chr

let rm_last_char t =
  if is_empty t then () else t := String.sub !t 0 (String.length !t - 1)

let get t = !t
let reset t = t := ""

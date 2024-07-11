type t = RGB of int * int * int | ANSI256 of int

let to_255 str =
  match int_of_string_opt ("0x" ^ str) with
  | None -> raise (Exn.OkalmExn (str ^ "is an invalid color"))
  | Some c -> c

let rgb r g b = RGB (to_255 r, to_255 g, to_255 b)

let rgb str =
  match String.to_seq str |> List.of_seq |> List.map (String.make 1) with
  | [ "#"; r1; r2; g1; g2; b1; b2 ] -> rgb (r1 ^ r2) (g1 ^ g2) (b1 ^ b2)
  | [ "#"; r1; g1; b1 ] -> rgb r1 g1 b1
  | _ -> raise (Exn.OkalmExn (str ^ "is an invalid color"))

let ansi256 value = ANSI256 value

let make str =
  if String.starts_with ~prefix:"#" str then rgb str
  else
    match int_of_string_opt str with
    | None -> raise (Exn.OkalmExn (str ^ "is an invalid color"))
    | Some i -> ansi256 i

let set_tty_color t =
  match t with
  | RGB (r, g, b) -> Format.sprintf "\x1b[38;2;%d;%d;%dm" r g b
  | ANSI256 c -> Format.sprintf "\x1b[38;5;%dm" c

let reset_tty () = "\x1b[0m"

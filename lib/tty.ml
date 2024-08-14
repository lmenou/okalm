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

module Pass = struct
  type password = Password of string

  module Rtty = struct
    let tty_set_echo_to value =
      let module U = Unix in
      let fd = U.stdin in
      if U.isatty fd then
        let termio = U.tcgetattr fd in
        let ntermio = { termio with c_echo = value } in
        U.tcsetattr fd U.TCSADRAIN ntermio
      else raise (Exn.OkalmExn "Not a valid tty")

    let read_pass () =
      try
        tty_set_echo_to false;
        let pass = read_line () in
        tty_set_echo_to true;
        Some pass
      with Exn.OkalmExn msg ->
        Printf.eprintf "%s" (msg ^ "\n");
        None
  end

  let getpass ~prompt_message =
    print_endline prompt_message;
    let pass = Rtty.read_pass () in
    match pass with
    | Some value -> Password value
    | None -> raise (Exn.OkalmExn "could not get the password")

  let string_of_password = function Password pass -> pass
end

module Style = struct
  type color = RGB of int * int * int | ANSI256 of int
  type effect = Bold | Italic | Underline

  let effect_code sty =
    let representation = function
      | Bold -> "1"
      | Italic -> "3"
      | Underline -> "4"
    in
    let res = List.map representation sty in
    String.concat ";" res

  (** The escape_tty_code to write color. *)
  let escape_tty_code = "\x1b[0m"

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

  let make = function
    | `RGB value ->
        if String.starts_with ~prefix:"#" value then rgb value
        else raise (Exn.OkalmExn (value ^ "is an invalid color."))
    | `ANSI256 value ->
        if value < 256 then ANSI256 value
        else raise (Exn.OkalmExn (string_of_int value ^ "is an invalid color."))

  let write_with ?(sty = []) color s =
    let effect = effect_code sty in
    let col = make color in
    match col with
    | RGB (r, g, b) ->
        let style = Format.sprintf "\x1b[38;2;%d;%d;%d;%sm" r g b effect in
        style ^ s ^ escape_tty_code
    | ANSI256 c ->
        let style = Format.sprintf "\x1b[38;5;%d;%sm" c effect in
        style ^ s ^ escape_tty_code
end

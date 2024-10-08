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

module OkalmDataHome : sig
  (** Module used to retrieve an $XDG_DATA_HOME/okalm folder for private data
    storage and configuration *)

  val get : string
  (** Return the expanded $XDG_DATA_HOME/okalm *)
end = struct
  let standard_location =
    try
      let home = Sys.getenv "HOME" in
      let module F = Filename in
      let rec concat folders =
        match folders with [] -> "" | hd :: tl -> F.concat hd (concat tl)
      in
      let no_user_error =
        Exn.OkalmExn "Not in a standard user environment, aborting"
      in
      let standard = concat [ home; ".local"; "share" ] in
      try
        if Sys.is_directory standard then F.concat standard "okalm"
        else raise no_user_error
      with Sys_error _ -> raise no_user_error
    with Not_found -> raise (Exn.OkalmExn "No $HOME, aborting")

  let okalm_data_home =
    try
      let config = Sys.getenv "XDG_DATA_HOME" in
      let module F = Filename in
      F.concat config "okalm"
    with Not_found -> standard_location

  let get =
    try
      if Sys.is_directory okalm_data_home then okalm_data_home
      else raise (Exn.OkalmExn "No okalm directory in $XDG_DATA_HOME, aborting")
    with Sys_error _ ->
      Unix.mkdir okalm_data_home 0o700;
      okalm_data_home
end

let store filename stored =
  let module O = Out_channel in
  let module F = Filename in
  let dest = OkalmDataHome.get in
  let write filename text =
    O.with_open_text (F.concat dest filename) (fun oc -> output_string oc text)
  in
  write filename stored

let exist filename =
  let module F = Filename in
  let dest = OkalmDataHome.get in
  let filename = filename in
  try
    let result = Sys.is_regular_file (F.concat dest filename) in
    result
  with Sys_error _ -> false

let unstore filename =
  let module I = In_channel in
  let module F = Filename in
  let dest = OkalmDataHome.get in
  let read filename = I.with_open_text (F.concat dest filename) input_line in
  read filename

let filled =
  let module U = Unix in
  let rdh = U.opendir OkalmDataHome.get in
  let numfile = ref 0 in
  let next () =
    try
      let _ = U.readdir rdh in
      incr numfile;
      true
    with End_of_file ->
      U.closedir rdh;
      false
  in
  let rec check_if_filled () =
    if next () then check_if_filled ()
    else if !numfile != 6 then false
    else true
  in
  check_if_filled ()

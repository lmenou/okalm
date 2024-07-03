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

let genchar () =
  (* choose char in the range of printable ASCII character *)
  let starting_at = 0x20 in
  let ending_at = 0x7E in
  let module R = Random in
  R.self_init ();
  let value = R.int (ending_at - starting_at) in
  Uchar.to_char @@ Uchar.of_int (value + starting_at)

let random_string keylength =
  let key = Bytes.create keylength in
  let rec genchar_pass_through ~from =
    if from = keylength then Bytes.to_string key
    else
      let _ = Bytes.set key from (genchar ()) in
      genchar_pass_through ~from:(from + 1)
  in
  genchar_pass_through ~from:0

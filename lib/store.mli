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

(** Module defining utilities to store the cryptographic keys used to
    encrypt files and folders. *)

val store : string -> string -> unit
(** [store filename content] write [content] in a file named [filename] in
    okalm's store. *)

val exist : string -> bool
(** [exist filename] checks the existence of a file named [filename] in
    okalm's store. *)

val unstore : string -> string
(** [unstore filename] reads the content of a file named [filename] in
    okalm's store and returns it. *)

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

(** Define utilities for password management. *)

module Pass : sig
  (** Define utilities for password management on the tty *)

  type password
  (** Define password type. *)

  val getpass : prompt_message:string -> password
  (** Get the user password without printing on the terminal. This is done by
    setting the echo attribute to false on the tty itself. *)

  val string_of_password : password -> string
  (** Return the string of the password. *)
end

module Style : sig
  (** Define utility to deal with colors on the tty. *)

  type effect =
    | Bold
    | Italic
    | Underline  (** Define the type for the effect style on font. *)

  val write_with :
    ?sty:effect list ->
    [< `ANSI256 of int | `RGB of string ] ->
    string ->
    string
  (** [write_with (`ANSI256 12) "my string"] return ["my string"] with the proper escaped sequence to print it in blue.

   [write_with (`RGB #161BA6) "my string"] is the same with true colors.

   [write_with ~sty:[ Bold; Italic ] (`RGB #161BA6) "my string"] add bold and italic effect with the blue color. *)
end

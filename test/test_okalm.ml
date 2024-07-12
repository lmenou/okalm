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

let () =
  let module A = Alcotest in
  A.run "Okalm"
    [
      ("Rgen", [ A.test_case "rgen" `Quick Test_rgen.test_rgen ]);
      ( "Tty",
        [
          A.test_case "Tty.Style write_with" `Quick
            Test_tty.Style.test_write_with;
        ] );
      ( "Keys",
        [
          A.test_case "Keys gen, string_of_key" `Quick Test_keys.test_gen;
          A.test_case "Keys aes_encrypt_key" `Quick Test_keys.test_encrypt_key;
          A.test_case "Keys.Crypt encrypt" `Quick Test_keys.Crypt.test_encrypt;
        ] );
    ]

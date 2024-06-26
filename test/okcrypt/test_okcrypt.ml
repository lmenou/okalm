let big_endian () =
  Alcotest.(check string)
    "same string" "50331648"
    (Okcrypt.Pbkdf.big_endian_int32 3);
  Alcotest.(check string)
    "same string" "754974720"
    (Okcrypt.Pbkdf.big_endian_int32 45);
  Alcotest.(check string)
    "same string" "1124073472"
    (Okcrypt.Pbkdf.big_endian_int32 67)

let pbkdf_length () =
  Alcotest.(check int)
    "same int" 32
    (String.length (Okcrypt.Pbkdf.pbkdf2 ~salt:"yo" "password"))

let pbkdf () =
  Alcotest.(check string)
    "same string"
    "\184\223\242\254\145\184(\150\024\250\221L0\147\130aCU\243XZ\210\143\201R\239\253\131\193\029\163\224"
    (Okcrypt.Pbkdf.pbkdf2 ~salt:"yo" "coucou")

let () =
  let module A = Alcotest in
  A.run "Okcrypt"
    [
      ("big-endian", [ A.test_case "Big endian" `Quick big_endian ]);
      ( "pbkdf",
        [
          A.test_case "Pbkdf length" `Quick pbkdf_length;
          A.test_case "Pbkdf non-randomness" `Quick pbkdf;
        ] );
    ]

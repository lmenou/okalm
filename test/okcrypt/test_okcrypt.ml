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

let () =
  let module A = Alcotest in
  A.run "Okcrypt"
    [
      ( "big-endian",
        [
          A.test_case "Big endian" `Quick big_endian;
        ] );
    ]


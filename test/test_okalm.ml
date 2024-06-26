let test_rgen () =
  Alcotest.(check int)
    "same int" 32
    (String.length (Okalm.Rgen.random_string 32))

let () =
  let module A = Alcotest in
  A.run "Okalm"
    [ ("rgen", [ A.test_case "Randomly generate string" `Quick test_rgen ]) ]

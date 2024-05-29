let genchar () =
  (* choose char in the range of printable ASCII character *)
  let starting_at = 0x20 in
  let ending_at = 0x7E in
  let module R = Random in
  R.self_init ();
  let value = R.int (ending_at - starting_at) in
  Uchar.to_char @@ Uchar.of_int (value + starting_at)

let get () =
  (* generate a 256 bit key *)
  let keybytelength = 32 in
  let key = Bytes.create keybytelength in
  for i = 0 to keybytelength - 1 do
    Bytes.set key i (genchar ())
  done;
  key

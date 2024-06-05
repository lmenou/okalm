module KeyStore : Store.Storage = struct
  let filename = "keygen"
end

type key = Key of bytes

let string_of_key = function Key value -> Bytes.to_string value

let genchar () =
  (* choose char in the range of printable ASCII character *)
  let starting_at = 0x20 in
  let ending_at = 0x7E in
  let module R = Random in
  R.self_init ();
  let value = R.int (ending_at - starting_at) in
  Uchar.to_char @@ Uchar.of_int (value + starting_at)

let get () =
  let create keylength =
    let key = Bytes.create keylength in
    let rec genchar_pass_through ~from =
      if from = keylength then key
      else
        let _ = Bytes.set key from (genchar ()) in
        genchar_pass_through ~from:(from + 1)
    in
    genchar_pass_through ~from:0
  in
  (* generate a 256 bit key *)
  Key (create 32)

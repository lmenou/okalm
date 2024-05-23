let nshow () =
  let buf = Input.create () in
  let rec accumulate () =
    let ch = Char.code (input_char stdin) in
    match ch with
    | 10 -> Input.get buf
    | code ->
        Input.add_char buf (Char.chr code);
        accumulate ()
  in
  accumulate ()

let getpass message =
  print_endline message;
  nshow ()

type password = Password of string | Null

module Rtty = struct
  let tty_set_echo_to value =
    let module U = Unix in
    let fd = U.stdin in
    if U.isatty fd then
      let termio = U.tcgetattr fd in
      let ntermio = { termio with c_echo = value } in
      U.tcsetattr fd U.TCSADRAIN ntermio
    else raise (Exn.OkalmExn "Not a valid tty")

  let read_pass () =
    try
      tty_set_echo_to false;
      let pass = read_line () in
      tty_set_echo_to true;
      Some pass
    with Exn.OkalmExn msg ->
      Printf.eprintf "%s" (msg ^ "\n");
      None
end

let getpass ~prompt_message =
  print_endline prompt_message;
  let pass = Rtty.read_pass () in
  match pass with Some value -> Password value | None -> Null

let string_of_password = function
  | Password pass -> pass
  | Null -> raise (Exn.OkalmExn "password is empty!")

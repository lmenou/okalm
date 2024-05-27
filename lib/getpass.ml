let tty_set_echo_to value =
  let module U = Unix in
  let fd = U.stdin in
  if U.isatty fd then
    let termio = U.tcgetattr fd in
    let ntermio = { termio with c_echo = value } in
    U.tcsetattr fd U.TCSADRAIN ntermio
  else Printf.eprintf "Not a valid tty\n"

let read_pass () =
  tty_set_echo_to false;
  let pass = read_line () in
  tty_set_echo_to true;
  pass

let getpass ~prompt_message =
  print_endline prompt_message;
  read_pass ()

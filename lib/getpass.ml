let tty_set_echo_to value =
  let module U = Unix in
  let fd = U.openfile "/dev/tty" [ U.O_RDWR ] 0o777 in
  let termio = U.tcgetattr fd in
  termio.c_echo <- value;
  U.tcsetattr fd U.TCSADRAIN termio;
  U.close fd

let read_pass () =
  tty_set_echo_to false;
  let pass = read_line () in
  tty_set_echo_to true;
  pass

let getpass ~prompt_message =
  print_endline prompt_message;
  read_pass ()

let tty_set_echo value =
  let module U = Unix in
  let fd = U.openfile "/dev/tty" [ U.O_RDWR ] 0o777 in
  let termio = U.tcgetattr fd in
  termio.c_echo <- value;
  U.tcsetattr fd U.TCSADRAIN termio;
  U.close fd

let read_pass () =
  tty_set_echo false;
  let pass = read_line () in
  tty_set_echo true;
  pass

let getpass message =
  print_endline message;
  read_pass ()

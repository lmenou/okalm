type key = Key of string

let string_of_key = function Key value -> value

let gen value =
  let length = String.length value / 2 in
  let second = Key (String.sub value 0 length) in
  let third = Key (String.sub value length length) in
  let first = Key (Rgen.random_string 32) in
  (first, second, third)

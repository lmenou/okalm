let split = function
  | Pbkdf.Key value ->
      let first = Pbkdf.Key (String.sub value 0 16) in
      let second = Pbkdf.Key (String.sub value 16 16) in
      (first, second)
  | Pbkdf.Null -> raise (Okcexn.OkcryptException "The given key cannot be null")

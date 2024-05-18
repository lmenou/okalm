module type Crypter = sig
  val crypter : string -> unit
end

module Crypter : Crypter = struct
  let crypter file =
    let module B = Bcrypt in
    let hash = B.hash file in
    print_endline @@ B.string_of_hash hash
end

(lang dune 3.15)

(name okalm)

(generate_opam_files true)

(source
 (github lmenou/okalm))

(authors "lmenou")

(maintainers "lmenou")

(license "GPL-3.0-or-later")

(package
 (name okalm)
 (synopsis "Encrypt your files, the ML way")
 (description "A command line tool to encrypt your files.")
 (tags (crypto cli))
 (depends
   ocaml
   dune
   cmdliner
   cryptokit
   (ocaml-lsp-server :build)
   (ocamlformat :build)
   (utop :build)
   (alcotest :with-test)
   (odoc :with-doc)
   (odig :with-doc)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

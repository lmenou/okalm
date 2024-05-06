(lang dune 3.15)

(name okalm)

(generate_opam_files true)

(source
 (github lmenou/okalm))

(authors "lmenou")

(maintainers "lmenou")

(license LICENSE)

(package
 (name okalm)
 (synopsis "Encrypt your files, the ML way")
 (description "A cli to encrypt your files")
 (depends ocaml dune cmdliner (alcotest :with-test) (ocaml-lsp-server :build)
          (ocamlformat :build) (odoc :with-doc) (utop :build)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

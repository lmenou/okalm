# Okalm

## About

:book: TIL Ocaml :camel:

:warning: :loudspeaker: DON'T use this for production, or CAREFULLY audit the code, if you dare. :rotating_light: :stop_sign:

This is a toy project to learn a bit about cryptography and
[Ocaml](https://ocaml.org/), not a serious one, learning should be fun.

It's a command line interface to encrypt simple and short text files.

```bash
$ okalm mypassword.txt
$ okalm --help
$ okalm --version
```

## How it works?

Here is the basic setup for the encryption.

### Setup

- Generate a random 128-bit key, _k1_, a random 128-bit IV, and a random salt.
- Use PBKDF2 to generate a 256-bit key from the given password and the salt
    - Split that into two 128-bit keys _k2_, _k3_.
- Use _k2_ to _AES_ encrypt _k1_ using the random IV.
- Save the encrypted key, _k3_, the salt and the IV to a file in `$XDG_DATA_HOME/okalm/`.

### Project

```bash
.
├── bin # Main entrypoint
├── lib # Okalm library
│   └── okcrypt # Okcrypt library
└── test # Tests for Okalm library
    └── okcrypt # Tests for Okcrypt library
```

## Disclaimer :rotating_light:

Doesn't work on Windows, I don't own a Windows machine, hence I couldn't test it on the OS.

## LICENSE :memo:

Licensed under the GNU-GPLv3.

## Contributions

Feel free to open an issue or a pull request if you have an idea to further
enhance the toy project.

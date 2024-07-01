## 0.0.3 (2024-07-01)

### Feat

- encrypt larger file
- add LICENSE

### Refactor

- simplify types management
- redefine properly keys
- use wrapper "with..." to encrypt files
- split concerns to handle progress
- separate writer and executor

## 0.0.2 (2024-06-21)

### Feat

- create README.md
- encrypt a short file
- add proof of concept of encryption
- introduce progress
- make a splitter
- add Pbkdf key type
- add pbkdf2 implementation
- add okcrypt library
- add store functor
- generate a random ASCII key
- store passkey in a file
- optimize okalm folder creation in xdg_data_home
- optimize the mutation of tty
- create $XDG_DATA_HOME/okalm
- abort cowardly on windows
- read password invisibly?
- accumulate password
- come back to file
- hash password

### Fix

- rename and re-organize modules
- change error names

### Refactor

- simplify storage
- simplify random string generation
- **okcrypt**: simplify lib
- rename keygen into salt
- rename set_tty_echo

## 0.0.1 (2024-05-06)

### Feat

- make initial commit

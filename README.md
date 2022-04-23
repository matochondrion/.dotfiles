# .dotfiles

1. Clone this repository and `cd .dotfiles`
2. Manually run steps in `install_instructions.txt`
  (Running `install.sh` is buggy and needs to be fixed too often)

### Current issues

- installing `nvim` plugins in `--headless` causes error output, but doesn't break installation
- Would like to improve the `install.sh` script
- Handle installation on different OS (MacOS, Linux, WSL2)

### Future optimizations

- Improve install script by automating step 2 above, initializing the `zsh` environment

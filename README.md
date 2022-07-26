# What is this?
This is my personal neovim config. Feel free to take bits of it to build your own or run it yourself.

As this is my personal config I am bound to change it a lot so I recommend forking rather then pointing to
this config.

# How to use
Clone the repo and run the following from the directory:
```
nix run .#
```
or
```
nix run github:gako358/nvimFlakes#.
```

# How to update plugins
```
nix flake update
```

# Folder structure
```
|-[lib] -- Contains my utility functions
|-[modules] -- Contains modules which are used to configure neovim
|-flake.nix -- Flake file
|-README.md -- This file
```

# License
The files and scripts in this repository are licensed under the MIT License, which is a very 
permissive license allowing you to use, modify, copy, distribute, sell, give away, etc. the software. 
In other words, do what you want with it. The only requirement with the MIT License is that the license 
and copyright notice must be provided with the software.


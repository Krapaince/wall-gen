# Wallpaper Generator

A script to generate nuance of wallpaper from an input wallpaper and a
color set file.

It uses
[colorbalance2](http://www.fmwconcepts.com/imagemagick/colorbalance2/index.php)
underneath to make wallpaper.

## Motivation

My [python script](https://github.com/Krapaince/dotfiles_linux/blob/12430186a7187aaad880563f16839fa6edd37029/dotfiles/local/bin/wallpaper.py) which handled wallpapers became too fat.

## Usage

```
Generate nuance of a wallpaper 0.0.1
Krapaince krapaince@pm.me

USAGE:
    wall-gen --color-set COLOR_SET --output OUTPUT --wallpaper WALLPAPER
    wall-gen --version
    wall-gen --help

OPTIONS:

    -c, --color-set        Color set                                                                                                    
    -o, --output           Generated wallpapers output directory                                                                        
    -w, --wallpaper        Wallpaper  
```

### Color set file
Colorset file is a json array such as:
```json
[
  { "l":  0,   "h":  0,  "r": 0,  "y": 0, "g": 0, "c": 5,  "b": 5,  "m": 0 },
]
```
Each key is an option forwarded to `colorbalance2`.

### Build

#### Requirements:
- Minimum supported elixir: `1.15`
- Minimum OTP: any that has support for elixir's version

---

```
mix escript.build
```

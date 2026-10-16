# Binbows Gothic theme

A dark purple theme for Notepad Next, with Material Symbols icons and floating rounded tabs.

This fork adds two things to Notepad Next v0.15:

- A `theme.lua` hook. At startup the app runs `theme.lua` if it sits next to `NotepadNext.ini`
  (on Linux: `~/.config/NotepadNext/`). Upstream has no way to recolour the editor.
- Material Symbols (outlined, v0.47.6) in place of the old toolbar and tab icons. `material-icon-map.txt`
  lists which symbol replaced which icon.

## Install the theme

```sh
cp theme.lua custom.css ~/.config/NotepadNext/
```

`theme.lua` recolours the editor. Every language's Notepad++ colours are remapped by hue onto the palette,
so all languages pick up the theme. `custom.css` restyles the window: menus, toolbar, tabs, status bar and
scrollbars.

## Build

```sh
QMAKE=/usr/bin/qmake6 cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j
```

## Palette

| Role | Colour |
| --- | --- |
| Page | `#0e0b14` |
| Text | `#e6dcc6` |
| Keywords, accent | `#b48cff` |
| Strings | `#9be55a` |
| Numbers | `#f0b45a` |
| Comments | `#8a7f9c` |

Material Symbols are by Google, under the Apache License 2.0.

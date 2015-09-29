# Installer Icon

This directory is for generating a (somewhat crude) installer icon in all the formats Windows wants. It's "somewhat crude" because in this case all resolutions are generated from a single SVG file. (Ideally, of course, we'd have resolution-specific/tweaked versions of the icons, and the makefile could accommodate that, it just hasn't been done yet.)

## Sources

The SVG contains the OSVG "block" logo, as well as the ["download" icon from FontAwesome](http://fortawesome.github.io/Font-Awesome/icon/download/) - specifically, via the split-out SVG available from <https://github.com/encharm/Font-Awesome-SVG-PNG/blob/master/black/svg/download.svg>

## Building

This requires a Unix-like shell with `make` (MSYS will do), Inkscape (to convert SVG to PNG), and ImageMagick/GraphicsMagick (to perform color palette conversions and the final `.ico` generation).

Make variables you might be interested in:

- `CONVERT` - if your `convert` executable from xMagick is named something else or needs a path.
- `INKSCAPE` - if your `inkscape` executable is named something strange or needs a path.

Targets:

- `icon` - this is the default target: does all the conversions, finally producing an `.ico` file.
- `clean` - removes all "intermediate" files: all generated files *except* the `.ico` file.
- `realclean` - removes all generated files, *including* the `.ico` file.

## Modifications

Since not everyone interacting with this repo will have the tools/setup required to do the build, the `.ico` file is committed. If you modify something in here that would change the output, please re-run `make` and commit the new `.ico`.

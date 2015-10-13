# Metadata Image Sources

This directory contains the source (high-res) images and scripts/makefiles to generate the `.ico` files required for a valid Microsoft device metadata package.

Microsoft has very specific requirements for the icon: while most of the time, the 256x256 full color plus alpha channel (essentially a 256x256 32-bit `.png` file) icon (or its downscaled variants) is used, at least the `DeviceMetadataWizard` enforces having all the sizes and color depths auto-generated here. While the auto-generated lower-color-depth versions are of course inferior to a manually-created one (and use an auto-generated palette rather than some standard palette), the fact that they will be seen so very rarely means it's likely not worth the effort to make them "better".

Image variations generated and embedded into the resulting `.ico` (dimensions are in pixels, one side length of a square icon):

- Full color with 8-bit alpha channel (32-bit `.png`)
	- 256
	- 48
	- 32
	- 24
	- 16
- 256-color with binary transparency (256-color `.gif`)
	- 48
	- 32
	- 24
	- 16
- 16-color with binary transparency (16-color `.gif`)
	- 48
	- 32
	- 24
	- 16

## Generating the `.ico`

All methods of producing the `.ico` from source image(s) require an install of either ImageMagick or GraphicsMagick (specifically, we use the `convert` executable), as well as a Bash or similar shell.

- The `makeicon.sh` scripts require just the above, and places all generated files in an `Output` subdirectory.
	- On Windows, git-bash works as long as you have `convert` in your path as you would with an install of it from Chocolatey).
- The `Makefile` also requires a sh-type `make` (such as one on *nix or in an environment like msys or cygwin) in addition to _Magick.
	- It works best on a *nix environment or an emulation thereof, thus...
	- On Windows, I used MSYS2/MinGW64 (haven't tested git-bash but I think it lacks `make`).

The intermediate files and output are not committed in this directory or subdirs (and are in fact gitignored), as the final output (the `.ico` file) is committed elsewhere in the repo, in the source directory for the corresponding metadata package. If you want to modify the images used in the metadata, you'll need to update the source image, run the generation script or makefile, then copy the resulting `.ico` file manually to replace the old one.

## Source Image Origins

All images have been (manually) placed on a transparent square canvas for use as input. If images did not already have a transparent background/alpha channel, the foreground has been extracted and placed on a transparent background.

- `beltbox` - Photograph of a HDK 1.2 "production" beltbox, taken and edited by Ryan Pavlik.
- `hdk` - Photorealistic 3D model renders in the `HDK Art` package from Razer
- `HDK-display` - Photorealistic 3D model render in the `HDK Art` package from Razer
- `ir-cam`- Photograph of the IR camera (without cables or tripod) shipped with a "production" HDK 1.2, taken and edited by Ryan Pavlik.
# IR Camera Needs Update Icon

This icon differs from the `ir-cam` one by the addition of two glyphs, to hopefully convey that the camera will likely not work as desired, and that updated firmware should be downloaded and installed.

## Sources

The SVG contains the `ir-cam` isolated photo, composed with two glyphs from [FontAwesome](https://fortawesome.github.io/Font-Awesome/), specifically the split-out SVG versions linked below:

- "download" in white from <https://github.com/encharm/Font-Awesome-SVG-PNG/blob/master/white/svg/download.svg>
- "exclamation-circle" in white from <https://github.com/encharm/Font-Awesome-SVG-PNG/blob/master/white/svg/exclamation-circle.svg>

## Building

The SVG contains the bitmap embedded in it, and is manually exported to the same size bitmap in the `input` directory before running the script. From the point of view of the script, no difference between this and the other directories.
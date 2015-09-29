

# Tool information/locations
# Invocations are quoted to help those folks on Windows who might have spaces in their path.
INKSCAPE := inkscape
CONVERT := convert

# Input/output setup
input := Installer.svg
output_stem := installer

downsample_resolutions := 16 24 32 48
full_resolutions := $(downsample_resolutions) 256
color_palettes = 16 256

original_output := $(foreach res,$(full_resolutions),$(output_stem)-$(res).png)
downsample_output := $(foreach colors,$(color_palettes),$(foreach res,$(downsample_resolutions),$(colors)/$(output_stem)-$(res).gif))
output := $(output_stem).ico

# Default target: build the icon
icon: $(output)

# Delete intermediate files/directories
clean:
	-rm -rf $(color_palettes) $(original_output) $(downsample_output)

# Delete all output, including the final .ico file.
realclean: clean
	-rm -rf $(output)

# Directories for downsampled color versions
$(color_palettes):
	mkdir -p $@

# Helper function for displaying useful status output.
define human-output
	@echo -e "\n*** Generating $@\n"
endef

# SVG to PNG with inkscape
$(output_stem)-%.png: $(input)
	$(human-output)
	"$(INKSCAPE)" --without-gui $< --export-png=$@ -w $* -h $*

# 16-color versions converted from PNG
16/$(output_stem)-%.gif: $(output_stem)-%.png 16
	$(human-output)
	"$(CONVERT)" $< -channel A -threshold 75% +channel -background hotpink -alpha background -colors 16 $@

# 256-color versions converted from PNG
256/$(output_stem)-%.gif: $(output_stem)-%.png 256
	$(human-output)
	"$(CONVERT)" $< -channel A -threshold 75% +channel -background hotpink -alpha background $@

$(output): $(original_output) $(downsample_output)
	$(human-output)
	"$(CONVERT)" $(original_output) $(downsample_output) $@

.PHONY: icon clean realclean

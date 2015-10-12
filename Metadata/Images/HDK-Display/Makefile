# Icon generation Makefile
# Authored by Sensics, Inc. <http://sensics.com/osvr>
#
# Copyright 2015 Sensics, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Tool information/locations
# Invocations are quoted to help those folks on Windows who might have spaces in their path.
CONVERT := convert

# Input/output setup
input := displaysource.png
output_stem := display

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

# Scale PNG
$(output_stem)-%.png: $(input)
	$(human-output)
	"$(CONVERT)" $< -resize $*x$* $@

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

# Device Metadata Sources

See <https://github.com/OSVR/OSVR-HDK-Windows-Drivers/wiki/MS-Device-Metadata> for more details.

## Files and directories

### Main build process and its input/output
Requires Python 2.x and the Jinja2 Python package (try `pip install -r requirements.txt` to get that installed). Also needs the `makecab.exe` tool, bundled with windows, so it's easiest to run this all on Windows.

- `build-metadata.cmd` - cleans up output from any previous builds then runs `build-metadata.py`. **This is the main/only script to run in this directory if you're building a combined installer.**
- `build-metadata.py` - "Compiles" the device metadata source directories into device metadata package files. See below for details on what specifically it does.
- `ddf-templates/` - Jinja2 templates used by `build-metadata.py` to create the `.ddf` file that describes to `makecab` exactly what we want constructed for each metadata package.
- Metadata package source directories:
	- `BeltBox/`
	- `HMDDisplay/`
	- `HMDOnly/`
  - `TrackingCamera/`
- `Output/` - a gitignored directory where generated output is placed. Each of the above source directory names will also exist as a subdirectory of `Output/`. Each of those subdirectories will contain the finished, uncompressed device metadata as well as the compressed device metadata package file.

### NSIS installer/section
- `build-metadata-installer.cmd` - Compiles an NSIS3 installer that just installs the device metadata. See also `../Combined-Installer/` that incorporates the guts of this installer into one that also contains other things.
- `HDKDeviceMetadata.nsi` - the NSIS3 script for the standalone installer mentioned above.
- `sign-metadata-installer.cmd` - signs the above installer.
- `DeviceMetadataSection.nsh` - The shared file included both by the standalone installer and the combined one.

### Other sources and tools
- `Images/` - The source images and scripts for the big pretty icons used here - see README in that directory.
- `MetadataInstallScript/` - Contains a PowerShell script with a batch file wrapper for elevation to automatically (and somewhat crudely - locale dir is hardcoded in script) install all device metadata packages found in the current working directory or below according to Microsoft's directions for "install by an application". Used to be used in the installers, now just left for testing/convenience.
- `MetadataInstallTool/` - Custom application/assemblies (requires .NET 4.0 Client Profile) for intelligently (as in, it opens up the packages and inspects them) installing device metadata files in the system metadata store, per Microsoft's directions for "install by an application": any arguments that are filenames of metadata packages get installed, any arguments that are directories get searched recursively for metadata packages that subsequently get installed. This is the current method used to install metadata inside of the various NSIS installers.

## What does `build-metadata.py` do?

- For each device metadata source directory:
	- Generates a new GUID (per MS recommendations) and timestamp.
	- Creates an output staging directory.
	- Parses parts of the metadata source to properly traverse and copy/format files, as well as determine the default locale.
	- Performs template substitution on the XML from the device metadata source directory trees (using Jinja2, treating the source as the "templates" and saving results to the appropriate staging directory), at this time primarily to propagate the GUID and timestamp
	- Copies the default locale's data to the non-locale-specific directory for Windows 7 support.
	- Generates the `.ddf` "diamond directive file" needed to configure `makecab` to produce the device metadata package file (which is a cab file with a funky extension), using a pair of Jinja2 templates
	- Runs `makecab` with the `.ddf` file to generate the final output `.devicemetadata-ms` "device metadata package" file

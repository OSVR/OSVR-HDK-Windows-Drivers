# Device Metadata Sources

See <https://github.com/OSVR/OSVR-HDK-Windows-Drivers/wiki/MS-Device-Metadata> for more details.

## Files and directories

### Main build process and its sources
- `build-metadata.cmd` - cleans up output from any previous builds then runs `build-metadata.py`
- `build-metadata.py` - Parses parts of the metadta source, runs the Jinja template engine on the device metadata source directory trees (saving results to a subdirectory of `Output`) to set a new GUID and updated timestamp, and also copies the default locale's data to the non-locale-specific directory for Windows 7 support. Finally, generates the `.ddf` "diamond directive file" and runs `makecab` with it to generate the output `.devicemetadata-ms` file (which is a cab file with a funky extension)
- Metadata package source directories:
	- `BeltBox/`
	- `HMDDisplay/`
	- `HMDOnly/`
  - `TrackingCamera/`

### NSIS installer/section
- `build-metadata-installer.cmd` - Compiles an NSIS3 installer that just installs the device metadata. See also `../Combined-Installer/` that incorporates the guts of this installer into one that also contains other things.
- `HDKDeviceMetadata.nsi` - the NSIS3 script for the standalone installer mentioned above.
- `sign-metadata-installer.cmd` - signs the above installer.
- `DeviceMetadataSection.nsh` - The shared file included both by the standalone installer and the combined one.

### Other sources and tools
- `Images/` - The source images and scripts for the big pretty icons used here - see README in that directory.
- `MetadataInstallScript/` - Contains a PowerShell script with a batch file wrapper for elevation to automatically (and somewhat crudely - locale dir is hardcoded in script) install all device metadata packages found in the current working directory or below according to Microsoft's directions for "install by an application". Used to be used in the installers, now just left for testing/convenience.
- `MetadataInstallTool/` - Custom application/assemblies (requires .NET 4.0 Client Profile) for intelligently (as in, it opens up the packages and inspects them) installing device metadata files in the system metadata store, per Microsoft's directions for "install by an application": any arguments that are filenames of metadata packages get installed, any arguments that are directories get searched recursively for metadata packages that subsequently get installed. This is the current method used to install metadata inside of the various NSIS installers.

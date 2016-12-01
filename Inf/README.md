# INF "Drivers"
This directory contains the `.inf` "driver" files for various hardware components (the actual kernel or user-mode drivers being used are all "in-box" drivers bundled with Windows, hence these files are just instructions).


## INF tools

**inf-checking.cmd** is a script bundled in this repo that runs both `ChkINF` and `infverif` on all the drivers in this directory.
They are both Windows Driver Kit tools with similar scope and purpose, but different rules and output.

**ChkINF** is a fairly old but widely used (though not "tested extensively", per MSDN) tool.
AFAICT, not everything it raises as a warning or error actually is one (false positives), but it can be useful.

MSDN documentation is at <https://msdn.microsoft.com/windows/hardware/drivers/devtest/chkinf>

*Output*: Start browsing from the `htm\summary.htm` file after running `inf-checking.cmd`.


**infverif** is a much newer tool, not based on a collection of Perl modules unlike `ChkINF`, but it seems to be considered "less authoritative" than `ChkINF` (at least in my impression from reading MSDN).
If you were actually building driver source code, it gets run as a part of that process.
The most frequently touted advantage (on MSDN) of it over `ChkINF` is determining if an inf is ["universal"](https://msdn.microsoft.com/library/windows/hardware/dn941087).
It similarly has false positives, though different ones.
(For instance, it reports errors related to missing sections that are actually in `Include`d infs.)

MSDN documentation is at <https://msdn.microsoft.com/en-us/windows/hardware/drivers/devtest/infverif>

*Output*: Start browsing from the `infverify\infverif.htm` file after running `inf-checking.cmd`.
Also, see the actual console output for a thumbs-up/thumbs-down "valid-NOT VALID" status of each inf, with the "NOT VALID" results tempered by checking which false positives triggered in the HTML output.

## INF Guidelines

The MS documentation on what "best practices" for making inf files can be self-contradictory, and often assumes you're starting with a sample inf file from the WDK (which none of these are, for licensing reasons - these are all written from scratch and Apache 2.0 licensed).
Here we try to distill the advice into a reasonably consistent set of guidelines, with references.



### "Manufacturer" section
<https://msdn.microsoft.com/windows/hardware/drivers/install/inf-manufacturer-section>

This link also shows how to branch the install for different operating system versions. See also <https://msdn.microsoft.com/en-us/windows/hardware/drivers/install/combining-platform-extensions-with-operating-system-versions>

Notes:

- Use the platform specifiers of the same format as you'd use in "Models" sections
	- Don't put an `NT` or `NT.bla` entry - these seem to be discouraged once you get down to the models sections.
- Windows 10 and up are selected with `NTx86.10`, `NTamd64.10`, etc.
- Windows 10 Anniversary Update (1607) and newer are selected by this format (note that only Win 10 1607 and newer support this format, earlier versions ignore these sections!): `NTx86.10.0...14393`, `NTamd64.10.0...14393`, etc

### "Models" sections
- All "Models" sections should be decorated with a "platform extension" (and all applicable/available platforms should be present) - no bare section names `[MY_MODEL]` or using `[MY_MODEL.NT]` to mean all platforms or x86.
	- https://msdn.microsoft.com/en-us/windows/hardware/drivers/install/creating-inf-files-for-multiple-platforms-and-operating-systems
	- also warned about by `infverif`
- Minimize the number of *DDInstall* sections (aka *install-section-name*) referenced by devices in the Models sections: devices that need the same setup can share the same *DDInstall* even if they're branded differently, and branches based on platform extension decorations don't need to imply different or decorated *DDInstall* sections (for all devices - naturally, it doesn't make too much sense in most cases to put an operating-system-version platform extension on a models section if all devices in it are setup the same as another operating-system-version platform extension.)
	- Along those lines, make the naming of the *DDInstall* sections fairly generic.
- Use a `%string.replacement%` for the device description part of each entry (the bit before the `=`)

### *DDInstall* sections and related install sections

<https://msdn.microsoft.com/en-us/windows/hardware/drivers/install/inf-ddinstall-section>

There are platform suffixes here, too, similar but different to those at the previous level.

- A bare `.NT` decoration is *not* deprecated here.
- Suffixes are required (you at least need a `.NT` if no differences between platforms exist) *except* in the case of drivers with no files to copy.
	- The docs say at least one per inf, but it may actually be at least one per device in the Models sections.
	- The given example of this exception in one place is monitor infs.
	- Infs that only use in-box driver files appear to *not* be an exception.
- It is not clear if the Windows version, etc. bits of platform suffixes are also usable here - if nothing else they are seen less often.

In the case that different actions (*DDInstall* sections or related sections like *DDInstall*.Services) must be taken based on the "platform extension":

- Decorated related install sections imply a requirement for a similarly decorated root *DDInstall* section and all other related install sections. (For instance, presence of *DDInstall*.ntx86.Services implies/requires the presence of *DDInstall*.ntx86. Further, if other install sections for a given *DDInstall* are required, like for instance a .HW section, it must also be similarly decorated: *DDInstall*.ntx86.HW)

	- https://msdn.microsoft.com/en-us/windows/hardware/drivers/install/combining-platform-extensions-with-other-section-name-extensions

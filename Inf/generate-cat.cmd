rem Make sure there are no spaces in the path to this batch file and that the inf is right alongside.

rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"

pushd "%~dp0"

rem Remove old build products
del *.cat *.htm > nul

rem "%WDK_DIR%\Tools\x86\infverif" *.inf /v /l .
rem start *.inf.htm

rem call "%WDK_DIR%\Tools\x86\chkinf\chkinf" *.inf

"%WDK_DIR%\bin\x86\inf2cat" /driver:. /os:10_X86,10_X64,6_3_X86,6_3_X64,6_3_ARM,Server6_3_X64,8_X64,8_X86,8_ARM,Server8_X64,Server2008R2_X64,Server2008R2_IA64,7_X64,7_X86,Server2008_X64,Server2008_IA64,Server2008_X86,Vista_X64,Vista_X86,Server2003_X64,Server2003_IA64,Server2003_X86,XP_X64,XP_X86

rem pnputil -a *.inf
rem pnputil -i -a *.inf

rem dpinst -C
popd
pause

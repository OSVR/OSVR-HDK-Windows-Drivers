rem Make sure there are no spaces in the path to this batch file and that the inf is right alongside.

@rem Edit these lines
@set CERTNAME=Sensics
@set DRIVER=osvr_cdc
@set WDK_DIR=%ProgramFiles(x86)%\Windows Kits\10

pushd "%~dp0"
del *.cat *.htm > nul

rem "%WDK_DIR%\Tools\x86\infverif" %DRIVER%.inf /v /l .
rem start %DRIVER%.inf.htm

rem call "%WDK_DIR%\Tools\x86\chkinf\chkinf" %DRIVER%.inf

"%WDK_DIR%\bin\x86\inf2cat" /driver:. /os:6_3_X86,6_3_X64,6_3_ARM,Server6_3_X64,8_X64,8_X86,8_ARM,Server8_X64,Server2008R2_X64,Server2008R2_IA64,7_X64,7_X86,Server2008_X64,Server2008_IA64,Server2008_X86,Vista_X64,Vista_X86,Server2003_X64,Server2003_IA64,Server2003_X86,XP_X64,XP_X86

"%WDK_DIR%\bin\x86\Signtool" sign /v /n %CERTNAME% /t http://timestamp.verisign.com/scripts/timstamp.dll %DRIVER%.cat

rem pnputil -a %DRIVER%.inf
rem pnputil -i -a %DRIVER%.inf

rem dpinst -C
popd
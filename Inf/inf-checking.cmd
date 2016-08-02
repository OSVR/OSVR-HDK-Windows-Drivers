rem Make sure there are no spaces in the path to this batch file and that the inf is right alongside.

rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"

pushd "%~dp0"

rem Remove old build products
del *.htm > nul
del /s /q htm > nul

"%WDK_DIR%\Tools\x86\infverif" *.inf /v /l .
rem start *.inf.htm

call "%WDK_DIR%\Tools\x86\chkinf\chkinf" *.inf
popd
pause

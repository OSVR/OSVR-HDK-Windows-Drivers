rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"
@echo off
IF %1.==. (
  echo.
	set /p INTERNALVER=Type two-component version desired:
) ELSE (
	set INTERNALVER=%1
)
@echo on

pushd "%~dp0"

rem Remove old build products - cat invalidated by timestamp change.
del *.cat *.htm > nul

rem Update the date to today and the version to 6.4.whateveryouentered
"%WDK_DIR%\bin\x86\stampinf" -f osvr_cdc.inf -d * -v 6.4.%INTERNALVER%

popd
pause

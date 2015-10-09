
rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"

pushd "%~dp0"
rem Remove old build products
del *.exe >nul

"%NSIS_DIR%\makensis" /DWDK_DIR="%WDK_DIR%" /DDRIVER_VER="%DRIVER_VER%" cdc-driver-installer.nsi

popd
pause

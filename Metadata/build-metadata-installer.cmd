
rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"

pushd "%~dp0"
rem Remove old build products
del *.exe >nul

"%NSIS_DIR%\makensis" /DDRIVER_VER="%DRIVER_VER%" HDKDeviceMetadata.nsi

popd
pause

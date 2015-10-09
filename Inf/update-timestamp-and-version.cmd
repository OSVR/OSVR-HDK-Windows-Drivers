rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"
pushd "%~dp0"

rem Remove old build products - cat invalidated by timestamp change.
del *.cat *.htm > nul

rem Update the date to today and the version to 6.4.whateveryouentered
"%WDK_DIR%\bin\x86\stampinf" -f osvr_cdc.inf -d * -v 6.4.%DRIVER_VER%

rem Update the date to today and the version to 1.0.whateveryouentered
"%WDK_DIR%\bin\x86\stampinf" -f osvr_hdk_display.inf -d * -v 1.0.%DRIVER_VER%

popd
pause
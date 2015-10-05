pushd "%~dp0"
pushd HDK-CDC
call generate-cat.cmd
popd
pushd HDK-CDC-NSIS-Installer
call build-cdc-driver-installer.cmd
popd
popd

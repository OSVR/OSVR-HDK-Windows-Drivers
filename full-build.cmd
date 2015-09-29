pushd "%~dp0"
pushd HDK-CDC
call generate-cat-and-sign.cmd
popd
pushd HDK-CDC-NSIS-Installer
call build-and-sign-cdc-driver-installer.cmd
popd
popd

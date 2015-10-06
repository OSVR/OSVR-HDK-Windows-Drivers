pushd "%~dp0"
pushd CDC
call generate-cat.cmd
call sign-cat.cmd
popd
pushd CDC-NSIS-Installer
call build-cdc-driver-installer.cmd
call sign-cdc-driver-installer.cmd
popd
popd

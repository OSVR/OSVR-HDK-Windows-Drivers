
@rem Edit these lines
@set CERTNAME=Sensics
@set WDK_DIR=%ProgramFiles(x86)%\Windows Kits\10
@set NSIS_DIR=%ProgramFiles(x86)%\NSIS

pushd "%~dp0"
del *.exe >nul

"%NSIS_DIR%\makensis" /DWDK_DIR="%WDK_DIR%" cdc-driver-installer.nsi
@rem "%NSIS_DIR%\makensis" /DWDK_DIR="%WDK_DIR%" silent-cdc-driver-installer.nsi

"%WDK_DIR%\bin\x86\Signtool" sign /v /n %CERTNAME% /t http://timestamp.verisign.com/scripts/timstamp.dll OSVR-HMD-CDC-Driver*.exe

popd

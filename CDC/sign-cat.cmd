rem Make sure there are no spaces in the path to this batch file and that the inf is right alongside.

rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"

pushd "%~dp0"

"%WDK_DIR%\bin\x86\Signtool" sign /v /ac "%WDK_DIR%\CrossCertificates\%CROSS_CERT%" /n %CERTNAME% /t %TIMESTAMP_SERVER% *.cat

popd

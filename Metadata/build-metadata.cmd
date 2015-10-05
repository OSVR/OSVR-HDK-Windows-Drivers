
rem Load the shared variable definitions.
call "%~dp0..\shared.cmd"

pushd "%~dp0"
rem Remove old build products
del /s /q Output\*.* >nul

python build-metadata.py
popd
pause

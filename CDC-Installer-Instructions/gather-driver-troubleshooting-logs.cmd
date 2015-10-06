@echo off
pushd "%~dp0"
setlocal
rem Configuration
set OUTFILE=driver-troubleshooting-logs.txt
set SUPPORT=support@osvr.com

rem Initial user output
echo.
echo Retrieving data for driver troubleshooting, please wait...
echo (Steps will be displayed during the process, in case the troubleshooter needs troubleshooting.)
echo =================================================================

rem Put some header information on the output file.
echo Start of driver troubleshooting logs > %OUTFILE%
date /T >> %OUTFILE%
echo. >> %OUTFILE%
echo Please attach this log, along with other information as directed about your problem, >> %OUTFILE%
echo to an email to the support helpdesk: %SUPPORT% >> %OUTFILE%
echo. >> %OUTFILE%
echo If you remove any portions due to privacy concerns, please clearly note this both in >> %OUTFILE%
echo the edited log file as well as the body of the support email. >> %OUTFILE%

rem START DATA GATHERING

rem This first section is different because "set" is a lousy heading
call :DoHeader Environment variables
set >> %OUTFILE%
echo.

rem Driver store
call :DoCommandSection dir /s "%systemroot%\system32\DriverStore\FileRepository\osvr_cdc.inf*"
call :DoCommandSection pnputil -e

rem SetupAPI - at least one will fail, that's OK
call :DoFileSection "%SystemRoot%\setupapi.log"
call :DoFileSection "%SystemRoot%\inf\setupapi.app.log"
call :DoFileSection "%SystemRoot%\inf\setupapi.dev.log"

rem DPInst
call :DoFileSection "%SystemRoot%\dpinst.log"

rem WMI through powershell
call :DoPOSHSection "Get-WmiObject -class Win32_PnPEntity -namespace 'root\CIMV2' | where {$_.DeviceID -like 'USB\*'} | select name,hardwareid,status,service,errordescription"
rem call :DoPOSHSection "Get-WmiObject -class Win32_PnPSignedDriver -namespace 'root\CIMV2' | where {$_.HardwareID -like 'USB\*'} | Select -Property * -ExcludeProperty __*,SystemProperties"
call :DoPOSHSection "Get-WmiObject -class Win32_PnPSignedDriver -namespace 'root\CIMV2' | where {$_.HardwareID -like 'USB\VID_1532&PID_0B00*'} | Select -Property * -ExcludeProperty __*,SystemProperties"

rem This doozy gets the data that shows up in "Events" in a device manager properties dialog.
call :DoPOSHSection "Get-WinEvent -FilterHashtable @{ProviderName=@('Microsoft-Windows-UserPnp','Microsoft-Windows-Kernel-PnP')}  | where {$_.Message.Contains('VID_1532&PID_0B00')} | select TimeCreated,Message | Sort-Object TimeCreated |fl"

rem END DATA GATHERING

rem OK, now just print the instructions to the terminal.
echo.
echo =================================================================
echo.
echo Done! Please attach:
echo %OUTFILE%
echo found in:
echo %CD%
echo along with other information about your problem as directed,
echo to an email to the support helpdesk: %SUPPORT%
echo.
echo If you must remove any portions of the log due to privacy concerns,
echo please clearly note this both in the edited log file as well as the
echo body of the support email.
echo.
pause

endlocal
popd
rem End of body of script.
goto :eof

rem "Functions" to reduce repetition
:DoHeader
echo.
echo - %*
echo. >> %OUTFILE%
echo ================================================= >> %OUTFILE%
echo %* >> %OUTFILE%
echo ================================================= >> %OUTFILE%
rem return
goto :eof

:DoCommandSection
call :DoHeader Command output: %*
cmd /c %* >> %OUTFILE%
echo.
rem return
goto :eof

:DoFileSection
call :DoHeader File contents: "%1"
type "%1" >> %OUTFILE%
echo.
rem return
goto :eof

:DoPOSHSection
call :DoHeader Powershell command output: %1
powershell -NoProfile -NonInteractive -Nologo -Command %1 >> %OUTFILE%
echo.
rem return
goto :eof

@rem Batch file containing shared environment variable definitions used by various scripts.

@rem This should be updated for each release
@set DRIVER_VER=1.2.8

@rem These are the default values, don't edit here, override - see below.
@set ROOTDIR=%~dp0
@set CERTNAME=Sensics
@set CROSS_CERT=DigiCert_Assured_ID_Root_CA.crt
@set TIMESTAMP_SERVER=http://timestamp.digicert.com
@set WDK_DIR=%ProgramFiles(x86)%\Windows Kits\10
@set NSIS_DIR=%ProgramFiles(x86)%\NSIS

@rem You can override defaults by making a config.cmd file, sample provided.
@if exist "%~dp0config.cmd" (
  call "%~dp0config.cmd"
)

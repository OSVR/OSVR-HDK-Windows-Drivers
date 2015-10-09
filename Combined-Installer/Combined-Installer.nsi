; Install wrapper for OSVR HMD combined CDC and device metadata installer
;
; Part of OSVR
; Authored by Sensics, Inc. <http://sensics.com/osvr>
;
; Copyright 2015 Sensics, Inc.
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
; 	http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

!define VERSION_TAG "v${DRIVER_VER}"
!define PRODUCT_NAME "OSVR HMD Drivers and Device Metadata"
!define PRODUCT_PUBLISHER "Sensics, Inc."
SetCompressor lzma

!include "x64.nsh"

Name "${PRODUCT_NAME}"
InstallDir "$TEMP\${PRODUCT_PUBLISHER} ${PRODUCT_NAME}"

RequestExecutionLevel "admin"

!define REPO_ROOT ".."
!define INSTALLER_ICON "${REPO_ROOT}\installer-icon\installer.ico"


OutFile "OSVR-HDK-Combined-Driver-Installer-${DRIVER_VER}.exe"

ShowInstDetails show

; MUI2 ------
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_ICON "${INSTALLER_ICON}"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Components page
;!insertmacro MUI_PAGE_COMPONENTS
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

!include "${REPO_ROOT}\Inf-NSIS-Installer\cdc-driver-installer-common.nsh"

!include "${REPO_ROOT}\Metadata\DeviceMetadataSection.nsh"

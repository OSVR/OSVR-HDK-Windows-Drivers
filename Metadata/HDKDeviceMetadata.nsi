; Install wrapper for OSVR HDK Device Metadata
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



!define PRODUCT_NAME "OSVR HDK Device Metadata"
!define PRODUCT_PUBLISHER "Sensics, Inc."
SetCompressor lzma

!include "x64.nsh"

Name "${PRODUCT_NAME}"
InstallDir "$TEMP\${PRODUCT_PUBLISHER} ${PRODUCT_NAME}"

RequestExecutionLevel "admin"

!define REPO_ROOT ".."

OutFile "OSVR-HDK-DeviceMetadata-${DRIVER_VER}.exe"

ShowInstDetails show

; MUI2 ------
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_ICON "${REPO_ROOT}\installer-icon\installer.ico"

; Welcome page
;!insertmacro MUI_PAGE_WELCOME
; Components page
;!insertmacro MUI_PAGE_COMPONENTS
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

;Section -SETTINGS
;  SetOutPath "$INSTDIR"
;  SetOverwrite ifnewer
;SectionEnd

!include "DeviceMetadataSection.nsh"

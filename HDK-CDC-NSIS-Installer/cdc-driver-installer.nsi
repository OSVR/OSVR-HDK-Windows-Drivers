; Install wrapper for OSVR HMD controller CDC serial port inf
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

; Shared starting stuff
!include "cdc-driver-installer-common-config.nsh"

OutFile "OSVR-HMD-CDC-Driver.exe"

ShowInstDetails show

!define DPINST_ARGS


; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_ICON "${OSVR_INSTALLER_ICON}"

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

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

; Shared ending stuff - the meat of the installer
!include "cdc-driver-installer-common.nsh"

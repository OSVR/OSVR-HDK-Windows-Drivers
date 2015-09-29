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

!define PRODUCT_NAME "OSVR HMD CDC Driver"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Sensics, Inc."
SetCompressor lzma

!include "x64.nsh"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "OSVR-HMD-CDC-Driver.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
ShowInstDetails show


; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_ICON "installer-icon\installer.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Components page
;!insertmacro MUI_PAGE_COMPONENTS
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Section -SETTINGS
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
SectionEnd


Section
  ; CDC driver inf
  File "HDK-CDC\osvr_cdc.inf"

  ; Signed catalog file
  File "HDK-CDC\osvr_cdc.cat"

  ; DIFx/DPInst configuration file
  File "HDK-CDC\dpinst.xml"

  ; Locally-vendored copies of dpinst from the WDK
  ; File /oname=$INSTDIR\dpinst32.exe redist\wdk10\x86\dpinst.exe
  ; File /oname=$INSTDIR\dpinst64.exe redist\wdk10\x64\dpinst.exe

  ; Directly-sourced versions of dpinst from the WDK, specified as a command-line define.
  File /oname=$INSTDIR\dpinst32.exe "${WDK_DIR}\Redist\DIFx\dpinst\EngMui\x86\dpinst.exe"
  File /oname=$INSTDIR\dpinst64.exe "${WDK_DIR}\Redist\DIFx\dpinst\EngMui\x64\dpinst.exe"

  ${If} ${RunningX64}
    ExecWait '"$INSTDIR\dpinst64.exe" /c /sw /PATH "$INSTDIR"'
  ${Else}
    ExecWait '"$INSTDIR\dpinst32.exe" /c /sw /PATH "$INSTDIR"'
  ${EndIf}

  ; Remove these helpers that were just for the installer's sake.
  Delete $INSTDIR\dpinst32.exe
  Delete $INSTDIR\dpinst64.exe
  Delete $INSTDIR\dpinst.xml ; TODO should we leave this behind?
SectionEnd

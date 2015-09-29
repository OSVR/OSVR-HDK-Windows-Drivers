; Install wrapper for OSVR HMD controller CDC serial port inf
; Common code between silent and "normal" installer
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





;Section -SETTINGS
;  SetOutPath "$INSTDIR"
;  SetOverwrite ifnewer
;SectionEnd


Section
  InitPluginsDir
  SetOutPath "$PLUGINSDIR"
  ; CDC driver inf
  File "${REPO_ROOT}\HDK-CDC\osvr_cdc.inf"

  ; Signed catalog file
  File "${REPO_ROOT}\HDK-CDC\osvr_cdc.cat"

  ; DIFx/DPInst configuration file
  File "dpinst.xml"

  File /oname=$PLUGINSDIR\osvr-installer.ico "${OSVR_INSTALLER_ICON}"

  ; Locally-vendored copies of dpinst from the WDK
  ; File /oname=$INSTDIR\dpinst32.exe redist\wdk10\x86\dpinst.exe
  ; File /oname=$INSTDIR\dpinst64.exe redist\wdk10\x64\dpinst.exe

  ; Directly-sourced versions of dpinst from the WDK, specified as a command-line define.
  File /oname=$PLUGINSDIR\dpinst32.exe "${WDK_DIR}\Redist\DIFx\dpinst\MultiLin\x86\dpinst.exe"
  File /oname=$PLUGINSDIR\dpinst64.exe "${WDK_DIR}\Redist\DIFx\dpinst\MultiLin\x64\dpinst.exe"

  StrCpy $DPINST_ARGS_RUNTIME ""
  IfSilent 0 SkipSilentFlag
  DetailPrint "silent-ish"
  StrCpy $DPINST_ARGS_RUNTIME "/sw" ; dpinst takes this arg to be silent-ish.
  SkipSilentFlag:

  DetailPrint "DPINST_ARGS_RUNTIME $DPINST_ARGS_RUNTIME"
  Var /GLOBAL DUMMY
  ${If} ${RunningX64}
    ExecWait '"$PLUGINSDIR\dpinst64.exe" ${DPINST_ARGS} $DPINST_ARGS_RUNTIME /PATH "$PLUGINSDIR"' $DUMMY ; dummy var to capture exit code
  ${Else}
    ExecWait '"$PLUGINSDIR\dpinst32.exe" ${DPINST_ARGS} $DPINST_ARGS_RUNTIME /PATH "$PLUGINSDIR"' $DUMMY ; dummy var to capture exit code
  ${EndIf}

  SetErrorLevel 0
  ;SetOutPath $TEMP
  ;RMDir /r $INSTDIR
SectionEnd

; Install wrapper for OSVR HMD controller CDC serial port inf
; Silent installer
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

!define DPINST_ARGS /SW

OutFile "OSVR-HMD-CDC-Driver-Quiet.exe"

Icon "${OSVR_INSTALLER_ICON}"

; Shared ending stuff - the meat of the installer
!include "cdc-driver-installer-common.nsh"

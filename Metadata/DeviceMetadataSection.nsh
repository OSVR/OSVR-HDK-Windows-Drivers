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

Section -DeviceMetadata
  InitPluginsDir
  SetOutPath "$PLUGINSDIR\metadata"
  ; PowerShell install script
  File "${REPO_ROOT}\Metadata\MetadataInstallScript\install-metadata.ps1"

  ; Metadata Files
  File "${REPO_ROOT}\Metadata\Output\HMDOnly\*.devicemetadata-ms"
  File "${REPO_ROOT}\Metadata\Output\BeltBox\*.devicemetadata-ms"
  File "${REPO_ROOT}\Metadata\Output\TrackingCamera\*.devicemetadata-ms"

  ExecWait "PowerShell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Unrestricted -Command '.\install-metadata.ps1'"

  SetOutPath $TEMP
  RMDir /r "$PLUGINSDIR\metadata"
  SetErrorLevel 0
SectionEnd

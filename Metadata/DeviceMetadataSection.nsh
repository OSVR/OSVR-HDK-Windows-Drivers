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

!include LogicLib.nsh
!include WinVer.nsh

!define METADATA_DIR $PLUGINSDIR\metadata

!define FIRMWARE_URL http://osvr.github.io/using/

Section -DeviceMetadata
  ${If} ${AtLeastWin7}
    InitPluginsDir
    SetOutPath "${METADATA_DIR}"

    ; C# install tool
    DetailPrint "Device metadata install tool:"
    File "${REPO_ROOT}\Metadata\MetadataInstallTool\DeviceMetadataInstallTool.exe"
    File "${REPO_ROOT}\Metadata\MetadataInstallTool\DeviceMetadataInstallTool.exe.config"
    File "${REPO_ROOT}\Metadata\MetadataInstallTool\Sensics.*.dll"

    ; Metadata Files
    DetailPrint "Device metadata packages:"
    File "${REPO_ROOT}\Metadata\Output\HMDDisplay\*.devicemetadata-ms"
    File "${REPO_ROOT}\Metadata\Output\HMDOnly\*.devicemetadata-ms"
    File "${REPO_ROOT}\Metadata\Output\BeltBox12\*.devicemetadata-ms"
    File "${REPO_ROOT}\Metadata\Output\BeltBox13\*.devicemetadata-ms"
    File "${REPO_ROOT}\Metadata\Output\TrackingCamera\*.devicemetadata-ms"
    File "${REPO_ROOT}\Metadata\Output\TrackingCameraNeedsUpgrade\*.devicemetadata-ms"

    ; Run the metadata installer.
    DetailPrint "Running device metadata install tool"
    nsExec::ExecToLog '"${METADATA_DIR}\DeviceMetadataInstallTool.exe" "${METADATA_DIR}"'
    Pop $0

    SetOutPath $TEMP
    RMDir /r "${METADATA_DIR}"
    SetErrorLevel 0

    DetailPrint "Adding device metadata static context menu items"

    ; v5
    WriteRegExpandStr HKCR "DeviceDisplayObject\HardwareId\USB#VID_0BDA&PID_57E8&REV_0005\Shell\FirmwareUpgrade" "MUIVerb" "Get firmware upgrade..."
    WriteRegStr HKCR "DeviceDisplayObject\HardwareId\USB#VID_0BDA&PID_57E8&REV_0005\Shell\FirmwareUpgrade\Command" "" "rundll32.exe url.dll,FileProtocolHandler ${FIRMWARE_URL}"

    ; v6
    WriteRegExpandStr HKCR "DeviceDisplayObject\HardwareId\USB#VID_0BDA&PID_57E8&REV_0006\Shell\FirmwareUpgrade" "MUIVerb" "Get firmware upgrade..."
    WriteRegStr HKCR "DeviceDisplayObject\HardwareId\USB#VID_0BDA&PID_57E8&REV_0006\Shell\FirmwareUpgrade\Command" "" "rundll32.exe url.dll,FileProtocolHandler ${FIRMWARE_URL}"
  ${Else}
    DetailPrint "Device Metadata is only usable on Windows 7 and newer."
  ${EndIf}
SectionEnd

# Copyright 2015 Sensics, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$locale = 'en-US'

$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Main()
{
	$dms = Join-Path (Get-DeviceMetadataStore) $locale
	if (!(Test-Path $dms)) {
		New-Item -Path $dms -ItemType directory
	}
	Get-ChildItem -Path $Root -Filter "*.devicemetadata-ms" -Recurse | ForEach-Object {
		Write-Host $_.FullName
		Copy-Item $_.FullName $dms | Out-Null
	}
	#Copy-Item
	#Read-Host "Press enter"
}
function Get-DeviceMetadataStore()
{
	# Based on
	# http://stackoverflow.com/questions/25049875/getting-any-special-folder-path-in-powershell-using-folder-guid
	Add-Type @"
		using System;
	    using System.Runtime.InteropServices;

	    public static class KnownFolder
	    {
			public static readonly Guid DeviceMetadataStore = new Guid("5CE4A5E9-E4EB-479D-B89F-130C02886155");
		}
	    public class shell32
	    {
	        [DllImport("shell32.dll")]
	        private static extern int SHGetKnownFolderPath(
	             [MarshalAs(UnmanagedType.LPStruct)]
	             Guid rfid,
	             uint dwFlags,
	             IntPtr hToken,
	             out IntPtr pszPath
	         );

	         public static string GetKnownFolderPath(Guid rfid)
	         {
	            IntPtr pszPath;
	            if (SHGetKnownFolderPath(rfid, 0, IntPtr.Zero, out pszPath) != 0)
	                return ""; // add whatever error handling you fancy
	            string path = Marshal.PtrToStringUni(pszPath);
	            Marshal.FreeCoTaskMem(pszPath);
	            return path;
	         }
	    }
"@
	return [shell32]::GetKnownFolderPath([KnownFolder]::DeviceMetadataStore)
}

#$DeviceMetadataStore = Join-Path ([Environment]::GetFolderPath("CommonApplicationData"))
#Set-StrictMode -Version 2
#Get-DeviceMetadataStore

Main

Clear-Host
$ErrorActionPreference = "SilentlyContinue"

$GracePeriod = (Invoke-WmiMethod -PATH (gwmi -namespace root\cimv2\terminalservices -class win32_terminalservicesetting).__PATH -name GetGracePeriodDays).daysleft
Write-Host -fore Green ======================================================
Write-Host -fore Green 'Terminal Server (RDS) grace period Days remaining are' : $GracePeriod
Write-Host -fore Green ======================================================  
Write-Host
$Response = Read-Host "Do you want to reset Terminal Server (RDS) Grace period to Default 120 Days ? (Y/N)"

if ($Response -eq "Y") {

$definition = @"
using System;
using System.Runtime.InteropServices; 
namespace Win32Api
{
	public class NtDll
	{
		[DllImport("ntdll.dll", EntryPoint="RtlAdjustPrivilege")]
		public static extern int RtlAdjustPrivilege(ulong Privilege, bool Enable, bool CurrentThread, ref bool Enabled);
	}
}
"@ 

Add-Type -TypeDefinition $definition -PassThru

$bEnabled = $false

$res = [Win32Api.NtDll]::RtlAdjustPrivilege(9, $true, $false, [ref]$bEnabled)

$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod", [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::takeownership)
$acl = $key.GetAccessControl()
$acl.SetOwner([System.Security.Principal.NTAccount]"Administrators")
$key.SetAccessControl($acl)

$rule = New-Object System.Security.AccessControl.RegistryAccessRule ("Administrators","FullControl","Allow")
$acl.SetAccessRule($rule)
$key.SetAccessControl($acl)

Remove-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod'

write-host
Write-host -ForegroundColor Red 'Resetting, Please Wait....'
Start-Sleep -Seconds 10 

  }

Else 
    {
Write-Host
Write-Host -ForegroundColor Yellow '**You Chose not to reset Grace period of Terminal Server (RDS) Licensing'
  }

tlsbln.exe
$GracePost = (Invoke-WmiMethod -PATH (gwmi -namespace root\cimv2\terminalservices -class win32_terminalservicesetting).__PATH -name GetGracePeriodDays).daysleft
Write-Host
Write-Host -fore Yellow =====================================================
Write-Host -fore Yellow 'Terminal Server (RDS) grace period Days remaining are' : $GracePost
Write-Host -fore Yellow =====================================================

Remove-Variable * -ErrorAction SilentlyContinue
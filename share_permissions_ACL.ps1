function GetSecurityDescriptor($ShareName) 
{ 
    # get specific share's LogicalShareSecuritySetting instance 
    $LSSS = Get-WmiObject -Class "Win32_LogicalShareSecuritySetting" | where {$_.Name -eq $ShareName} 
    ################################################################################################################## 
    # if get remote object: 
    # $Credential = Get-Credential $domain\$username 
    # $LSSS = Get-WmiObject -Class "Win32_LogicalShareSecuritySetting" -ComputerName $ServerName -Namespace root\cimv2  
    # -Credential $Credential | where {$_.Name -eq $ShareName} 
    ################################################################################################################## 
 
    $Result = $LSSS.GetSecurityDescriptor() 
    if($Result.ReturnValue -ne 0) 
    { 
        throw "GetSecurityDescriptor Failed" 
    } 
    # if return value is 0, then we can get its security descriptor  
    $SecDescriptor = $Result.Descriptor 
    return $SecDescriptor 
} 
 
function SetShareInfo($ShareName,$SecDescriptor) 
{ 
    # get specific share's instance 
    $Share = Get-WmiObject -Class "Win32_Share" | where {$_.Name -eq $ShareName} 
    ################################################################################################################## 
    # if get remote object: 
    # $Share = Get-WmiObject -Class "Win32_Share" -ComputerName $ServerName -Namespace root\cimv2  
    # -Credential $Credential | where   {$_.Name -eq $ShareName} 
    ################################################################################################################## 
 
    $MaximumAllowed = [System.UInt32]::MaxValue 
    $Description = "After remove permission" 
    $Access = $SecDescriptor 
    $Result = $Share.SetShareInfo($MaximumAllowed,$Description,$Access) 
    if($Result.ReturnValue -ne 0) 
    { 
        throw "SetShareInfo Failed" 
    } 
    "Success!" 
} 
 
function GetIndexOf($DACLs,$Domain,$Username) 
{ 
    $Index = -1; 
    for($i = 0; $i -le ($DACLs.Count - 1); $i += 1) 
    { 
        $Trustee = $DACLs[$i].Trustee 
        $CurrentDomain = $Trustee.Domain 
        $CurrentUsername = $Trustee.Name 
         
        if(($CurrentDomain -eq $Domain) -and ($CurrentUsername -eq $Username)) 
        { 
            $Index = $i 
        } 
    } 
    return $Index 
} 
 
function RemoveDACL($DACLs,$Index) 
{ 
    if($Index -eq 0) 
    { 
        $RequiredDACLs = $DACLs[1..($DACLs.Count-1)] 
    } 
    elseif ($Index -eq ($DACLs.Count-1)) 
    { 
        $RequiredDACLs = $DACLs[0..($DACLs.Count-2)] 
    } 
    else 
    { 
        $RequiredDACLs = $DACLs[0..($Index-1) + ($Index+1)..($DACLs.Count-1)] 
    } 
    return $RequiredDACLs 
} 
 
function RemoveSharePermissionOf($Domain,$Username,$ShareName) 
{ 
    $SecDescriptor = GetSecurityDescriptor $ShareName 
    # get DACL 
    $DACLs = $SecDescriptor.DACL 
    # no DACL 
    if($DACLs -eq $null) 
    { 
        "$ShareName doesn't have DACL" 
        return 
    } 
    # find the specific DACL index 
    $Index = GetIndexOf $DACLs $Domain $Username 
    # not found 
    if($Index -eq -1) 
    { 
        "User $Domain\$Username Not Found on Share $ShareName" 
        return 
    } 
    # remove specific DACL 
    if(($DACLs.Count -eq 1) -and ($Index -eq 0)) 
    { 
        $RequiredDACLs = $null 
    } 
    else 
    { 
        $RequiredDACLs = RemoveDACL $DACLs $Index 
    } 
    # set DACL 
    $SecDescriptor.DACL = $RequiredDACLs 
     
    SetShareInfo $ShareName $SecDescriptor 
} 
$Domain="" 
$Username="EVERYONE" 
$ShareName="" 
RemoveSharePermissionOf $Domain $Username $ShareName
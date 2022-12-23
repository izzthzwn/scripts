
$workdir = "."
$filedate = $(Get-Date).ToString("yyyyMMdd-HHmm")
$filename = "Azure_Disks_Info"
$tenant_id = "3b2e8941-7948-4131-978a-b2dfc7295091"
$client_id = "2ba9bfbc-e3ce-4d9b-9063-dc40fc998a7c"
$client_secret = "*k:bL.SSvWG3_dlk3Cnq0vUNix4Tfs1E"

$token_req = Invoke-RestMethod -Uri https://login.microsoftonline.com/$tenant_id/oauth2/token?api-version=1.0 -Method Post -Body @{"grant_type" = "client_credentials"; "resource" = "https://management.core.windows.net/"; "client_id" = "$client_id"; "client_secret" = "$client_secret" }
$token = $token_req.access_token

$headers = @{
    'authorization'="Bearer $token"
    'host'='management.azure.com'
    'contentype'='application/json'
}

$res_arr = @()
$obj_i = 1
$subscriptions_ep = "https://management.azure.com/subscriptions?api-version=2016-06-01"
$subscriptions_req = Invoke-RestMethod -Uri $subscriptions_ep -Headers $headers -Method GET
$subscriptions = $subscriptions_req.value

# To filter results by subscription
#$subscriptions = $subscriptions_req.value | Where-Object { $_.displayName -eq "PTAZSG-DEV ENVIRONMENT" }

foreach ( $subscription  in $subscriptions ) {

    $obj_ep = "https://management.azure.com/subscriptions/"+$subscription.subscriptionId+"/providers/Microsoft.Compute/disks?api-version=2018-06-01"
    $obj_req = Invoke-RestMethod -Uri $obj_ep -Headers $headers -Method GET

    $obj_arr = $obj_req.value
    $obj_arr_nextlink = $obj_req.nextLink

    while ( $null -ne $obj_arr_nextlink ){
        $obj_req = (Invoke-RestMethod -Uri $obj_arr_nextlink -Headers $headers -Method Get)
        $obj_arr_nextlink = $obj_req.nextLink
        $obj_arr += $obj_req.value
    }

    "{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - [ "+$subscription.displayName+" ] Querying Azure disk(s). "+$obj_arr.Count+" disk(s) found. "

    if( $obj_arr.Count -gt 0){
        foreach ( $obj in $obj_arr ) {

            $Disk_Name = $obj.name
            $Disk_State = $obj.properties.diskState 
            $Location = $obj.location
            $OS_type = $obj.properties.osType
            $SKU_name = $obj.sku.name
            $SKU_tier = $obj.sku.tier
            
            if( [string]::IsNullOrEmpty($obj.properties.diskSizeGB) ){ $Disk_Size = 0 } else { $Disk_Size = $obj.properties.diskSizeGB }

            # Get VM info 
            if( [string]::IsNullOrEmpty($obj.managedBy) ){ 
                $VM_name = "" 
            } else { 
                $VM_name = $obj.managedBy.Split('/')[8] 
            }
            
            # Get disk encyption info 
            if( [string]::IsNullOrEmpty($obj.properties.encryptionSettings) ){
                $Is_Encrypted = ""
                $EncKey_Vault_Name = ""
                $EncKey_Secret_Url = ""
                $EncKey_KEK_Name = ""
                $EncKey_KEK_Version = ""
                $EncKey_KEK_Url = ""
            } else {
                $Is_Encrypted = $obj.properties.encryptionSettings.enabled

                if( [string]::IsNullOrEmpty($obj.properties.encryptionSettings.diskEncryptionKey) ){
                    $EncKey_Vault_Name = ""
                    $EncKey_Secret_Url = ""
                } else {
                    $EncKey_Vault_Name = $obj.properties.encryptionSettings.diskEncryptionKey.sourceVault.id.Split('/')[8]
                    $EncKey_Secret_Url = $obj.properties.encryptionSettings.diskEncryptionKey.secretUrl
                }

                if( [string]::IsNullOrEmpty($obj.properties.encryptionSettings.keyEncryptionKey) ){
                    $EncKey_KEK_Name = ""
                    $EncKey_KEK_Version = "" 
                    $EncKey_KEK_Url = ""                
                } else {
                    $EncKey_KEK_Name = $obj.properties.encryptionSettings.keyEncryptionKey.keyUrl.Split('/')[4]
                    $EncKey_KEK_Version = $obj.properties.encryptionSettings.keyEncryptionKey.keyUrl.Split('/')[5]
                    $EncKey_KEK_Url = $obj.properties.encryptionSettings.keyEncryptionKey.keyUrl
                }
            }

            $res_arr += [PSCustomObject]@{
                Disk_Name = $Disk_Name
                Disk_Size_GB = $Disk_Size
                Disk_State = $Disk_State
                SKU_name = $SKU_name
                SKU_tier = $SKU_tier
                Location = $Location
                OS_type = $OS_type
                VM_name = $VM_name
                Is_Encrypted = $Is_Encrypted
                Key_Vault_Name = $EncKey_Vault_Name
                Key_Secret_Url = $EncKey_Secret_Url
                KEK_Name = $EncKey_KEK_Name
                KEK_Version = $EncKey_KEK_Version
                KEK_Url = $EncKey_KEK_Url
                ResourceGroup = $obj.id.Split('/')[4]
                Subscription = $subscription.displayName
            }

            $obj_i++
        }    
    }
} 
    
$output_file_csv = "$($workdir)\$($filename)_$($filedate).csv"

"{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - Exporting all Azure disks info to "+$output_file_csv
$res_arr | Export-Csv -Path $output_file_csv -NoTypeInformation

#$res_arr | Where-Object { $_.Is_Encrypted -eq "TRUE" } | ConvertTo-Json

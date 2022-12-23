#$sub_id = "5f782fe2-8948-4fd8-8bce-a09ad5d3cb62"
#$sub_name = "PTAZSG-PROD ENVIRONMENT"

#$sub_id = "b5a67ad5-d38a-4258-aa5e-31e39d3b709f"
#$sub_name = "PTAZSG-DEV ENVIRONMENT"

$sub_id = "b9c4e2a3-a10d-4a47-94b7-0fb93b30690f"
$sub_name = "PTAZSG-UAT ENVIRONMENT"

$vm_name = "PTSG-4TAXap3"
$vm_rg = "PTAZSG-UAT-TAXBW-RG"

$key_vault_rg = "PTAZSG-UAT-COCOPS-RG"
$key_vault_name = "PTAZSG-UAT-KV"
$key_enckey_name = "PTAZSG-UAT-VmDiskEncryption-RSA-HSM-KEK"    # KEK name
$enc_volume_type = "All"    # Accepted values:	OS, Data, All, ** For Windows VM, please use All or OS

# Select Azure subscription
"{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - [ "+$sub_name+" ] Selecting subscription "+$sub_id
Select-AzSubscription -Subscription $sub_id

# Select Azure disk encryption status
"{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - [ "+$sub_name+" ] Disk encryption status for VM "+$vm_name
Get-AzVmDiskEncryptionStatus -ResourceGroupName $vm_rg -VMName $vm_name

"{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - [ "+$sub_name+" ] Get Key Vault info for "+$key_vault_name
$key_vault = Get-AzKeyVault -VaultName $key_vault_name -ResourceGroupName $key_vault_rg
$key_vault_url = $key_vault.VaultUri
$key_vault_id = $key_vault.ResourceId
$key_enckey_url = (Get-AzKeyVaultKey -VaultName $key_vault_name -Name $key_enckey_name).Key.kid
$key_sequence_ver = [Guid]::NewGuid()

$key_enckey_url

# to start encryption an VM
# This prepares the VM and enables encryption which may reboot the machine and takes 10-15 minutes to finish
"{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - [ "+$sub_name+" ] Installing disk encryption extension for VM "+$vm_name+" using KEK "+$key_enckey_name


Set-AzVMDiskEncryptionExtension -ResourceGroupName $vm_rg `
                                -VMName $vm_name `
                                -DiskEncryptionKeyVaultUrl $key_vault_url `
                                -DiskEncryptionKeyVaultId $key_vault_id `
                                -KeyEncryptionKeyUrl $key_enckey_url `
                                -KeyEncryptionKeyVaultId $key_vault_id `
                                -SequenceVersion $key_sequence_ver `
                                -VolumeType $enc_volume_type `
                                -skipVmBackup `
                                -Force


"{0:yyyy-MM-dd HH:mm:ss}" -f (Get-Date) +" - [ "+$sub_name+" ] Disk encryption extension installation for VM "+$vm_name+" completed "

#Connect to an ESX/ESXi host or vCenter Server using PowerCLI       
Connect-VIServer 10.14.221.20 -User administrator@vsphere.local -Password XXXXXXX

#set datastore location/name
$dsName = 'T4_VPLEX01_V56_ESX_CPRDCLUS_DS_LUN249'

#set folder name in datastore
$folder = 'VCENPWINTEL02'

#Get a datastore object:
$ds = Get-Datastore -Name $dsName

#Create a new PowerShell drive, such as ds:, that maps to $datastore: 
New-PSDrive -Location $ds -Name DS -PSProvider VimDatastore -Root "\"


#Get all items in the datastore/folder
Get-ChildItem -Path "DS:/$folder" -Recurse


#copy items for datastore
Copy-DatastoreItem -Item DS:\$folder\VCENPWINTEL02-92392235.vmss -Destination C:\temp

Copy-DatastoreItem -Item DS:\$folder\VCENPWINTEL02-Snapshot1.vmsn -Destination C:\temp

#remove temp PSdrive
Remove-PSDrive -Name DS -Confirm:$false

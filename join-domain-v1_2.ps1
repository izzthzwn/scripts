$domain = "petronas.petronet.dir"
$hostname = hostname
$FQDN = $hostname + $domain
$domainUser="a-izzat"
$domainPassword="password"
$secPassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
$userName=$domain+'\'+$domainUser
$credential = New-Object System.Management.Automation.PSCredential($userName, $secPassword)

$2019ou = "OU=WIN2019,DC=PETRONAS,DC=PETRONET,DC=DIR"
$2016ou = "OU=WIN2016,DC=PETRONAS,DC=PETRONET,DC=DIR"
$2012ou = "OU=WIN2012,DC=PETRONAS,DC=PETRONET,DC=DIR"
$2008ou = "OU=WIN2008,DC=PETRONAS,DC=PETRONET,DC=DIR"

# check OS version
$a = Get-CimInstance Win32_OperatingSystem | Select-Object  Caption

"OS version = " + $a.Caption

$text = "OS version = " + $a.Caption
$text | Add-Content .\join-domain.log

#Assign OU path based on OS version
if ($a.caption -like '*2016*')
{
$oupath = $2016ou
}

elseif ($a.caption -like '*2012*')
{
$oupath = $2012ou
}

elseif ($a.caption -like '*2008*')
{
$oupath = $2008ou
}

elseif ($a.caption -like '*2019*')
{
$oupath = $2019ou
}

"OU path = " + $oupath

$text = "OU path = " + $oupath
$text | Add-Content .\join-domain.log

# Nslookup to ensure the hostname doesnt exists in DNS
$domain_check = Resolve-DnsName -Name $FQDN -erroraction 'silentlycontinue'

try {

if ($domain_check -eq $null)
{
"Joining server to the domain.."
$text = "Joining server to the domain.."
$text | Add-Content .\join-domain.log

#Start joining domain
#Add-Computer -DomainName "petronas.petronet.dir" -OUPath $oupath -ErrorAction stop
Add-Computer -DomainName $domain -OUPath $oupath -Credential $credential

$text = "Successful join the server to PETRONAS domain"
$text | Add-Content .\join-domain.log

$text = "Restarting computer.."
$text | Add-Content .\join-domain.log
#prompt to restart computer
Restart-Computer -Confirm

}

#return error if found the same hostname in DNS
elseif ($domain_check -ne $null)
{
"Failed to join domain. The computer object may already exists. Please change the hostname or escalate to WINTEL team"
$text = "Failed to join domain. The computer object may already exists. Please change the hostname or escalate to WINTEL team"
$text | Add-Content .\join-domain.log
}

} #end try

Catch
{
$ErrorMessage = $_.Exception.Message
$ErrorMessage
}









#June
$2012R2 = '*KB4503276*'
$2012 = '*KB4503285*'
$2008R2 = '*KB4503292*' 
$2016 = '*KB4503267*'

#July
$2012R2 = '*KB4507448*'
$2012 = '*KB4507462*'
$2008R2 = '*KB4507449*' 
$2016 = '*KB4507460*' 

$Session = New-Object -ComObject "Microsoft.Update.Session" 
$Searcher = $Session.CreateUpdateSearcher() 
$historyCount = $Searcher.GetTotalHistoryCount() 
$a = $Searcher.QueryHistory(0, $historyCount) | where {$_.title -like $2012R2 -or $_.title -like $2012 -or $_.title -like $2008R2 -or $_.title -like $2016} | Select-Object @{name="Status"; expression={switch($_.resultcode){ 
 
       1 {"Pending Reboot"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"}; 
 
       4 {"Failed"}; 5 {"Cancelled"} 
 
}}}

if ($a -ne $null)
    {
    
   $a | Select-Object -ExpandProperty status
 
   }

elseif ($a -eq $null)
    {
    "Patch not install yet"
    }
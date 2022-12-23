Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Confirm:$false


Start-Process -FilePath "C:\Temp\ndp48-x86-x64-allos-enu.exe" -ArgumentList "/q /norestart" -wait


#Start-Process "\\10.13.14.198\wintel\NDP472-KB4054530-x86-x64-AllOS-ENU.exe" -ArgumentList "/q /norestart" -Wait 


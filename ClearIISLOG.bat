forfiles /p "C:\inetpub\logs\LogFiles" /s /m *.log /c "cmd /c Del @path" /d -60
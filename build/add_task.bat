%SYSTEMROOT%\system32\schtasks.exe /create /tn "Citation" /tr "\"%1\"" /sc MINUTE /mo 1
pause

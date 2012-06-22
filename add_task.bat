REM
REM Copyright 2012 (C) NetVersa, LLC.
REM All rights reserved.
REM

%SYSTEMROOT%\system32\schtasks.exe /create /tn "Citation" /tr "\"%1\"" /sc MINUTE /mo 1
pause

netsh firewall add portopening TCP 7055 web

netsh advfirewall firewall add rule name="Citation Service" dir=out action=allow profile=any description="Business Citation Service" program="%~1\files\citationCheck.exe"

netsh firewall add allowedprogram "%~1\files\citationCheck.exe" Exerb ENABLE

netsh firewall add allowedprogram "%~1\files\gusto.exe" Gusto ENABLE

netsh firewall add allowedprogram "%~1\files\login.exe" Login ENABLE

netsh advfirewall firewall add rule name="Citation Service Gusto" dir=out action=allow profile=any description="Business Citation Service" program="%~1\files\gusto.exe"

netsh advfirewall firewall add rule name="Citation Service Login" dir=out action=allow profile=any description="Business Citation Login" program="%~1\files\login.exe"

%~1\files\firefox.exe -ms

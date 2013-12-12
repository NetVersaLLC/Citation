netsh firewall add portopening TCP 7055 web

netsh advfirewall firewall add rule name="Citation Service" dir=out action=allow profile=any description="Business Citation Service" program="%~1\files\citationCheck.exe"

netsh firewall add allowedprogram "%~1\files\citationCheck.exe" Exerb ENABLE

netsh firewall add allowedprogram "%~1\files\gusto.exe" Gusto ENABLE

netsh advfirewall firewall add rule name="Citation Service Gusto" dir=out action=allow profile=any description="Business Citation Service" program="%~1\files\gusto.exe"

%~1\files\firefox.exe -ms

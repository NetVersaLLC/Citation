mkdir %~4\%~5\%~1\

msbuild .\Uninstaller\Uninstaller.csproj /t:clean;rebuild /p:Configuration=Release /p:ProductName="%~1" /p:ApplicationVersion="%~3"
signtool sign /f src\certs\netversa.pfx /p FWq31i1GSl /t http://timestamp.comodoca.com/authenticode .\Citation\Uninstaller\obj\x86\Release\Uninstaller.exe

msbuild .\CitationClient\CitationClient.csproj /t:clean;rebuild;publish /p:Configuration=Release /p:ProductName="%~1" /p:AssemblyName="%~1" /p:InstallUrl="%~2" /p:PublishDir="..\\%~4\\%~5\\%~1\\" /p:PublisherName="%~1" /p:ApplicationVersion="%~3" /p:AsmPublishUrl="%~2%~1.application" /p:AsmVersion=%~3 /p:AsmFileVersion=%~3 /p:AsmProduct="%~1 Client"
signtool sign /f src\certs\netversa.pfx /p FWq31i1GSl /t http://timestamp.comodoca.com/authenticode .\CitationInstaller\%~1.exe


copy .\src\labels\%~1\license.rtf .\CitationInstaller\
msbuild .\CitationInstaller\CitationInstaller.csproj /t:clean;rebuild /p:Configuration=Release /p:ProductName="%~1 Setup" /p:AsmVersion=%~3 /p:AsmFileVersion=%~3 /p:AsmPublishUrl="%~2%~1.application" /p:AsmTitle=%~1 /p:AsmProduct=%~1
signtool sign /f src\certs\netversa.pfx /p FWq31i1GSl /t http://timestamp.comodoca.com/authenticode .\CitationInstaller\bin\release\setup.exe

copy .\CitationInstaller\bin\release\setup.exe %~4\%~5\%~1\

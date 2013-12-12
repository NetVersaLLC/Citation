mkdir .\src\labels\%~1\publish
msbuild .\CitationClient\CitationClient.csproj /t:clean;rebuild;publish /p:Configuration=Release /p:ProductName="%~1" /p:AssemblyName="%~1" /p:InstallUrl="%~2" /p:PublishDir="..\\src\\labels\\%~1\\publish\\" /p:ApplicationVersion="%~3"


copy .\src\labels\%~1\AssemblyInfo.cs .\CitationInstaller\Properties
copy .\src\labels\%~1\license.rtf .\CitationInstaller\
msbuild .\CitationInstaller\CitationInstaller.csproj /t:clean;rebuild /p:Configuration=Release /p:ProductName="%~1 Setup"
copy .\CitationInstaller\bin\release\setup.exe .\src\labels\%~1\publish
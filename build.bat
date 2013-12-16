mkdir %~4\%~5\%~1\
msbuild .\CitationClient\CitationClient.csproj /t:clean;rebuild;publish /p:Configuration=Release /p:ProductName="%~1" /p:AssemblyName="%~1" /p:InstallUrl="%~2" /p:PublishDir="..\\%~4\\%~5\\%~1\\" /p:ApplicationVersion="%~3" /p:AsmPublishUrl="%~2%~1.application" /p:AsmVersion=%~3 /p:AsmFileVersion=%~3


copy .\src\labels\%~1\license.rtf .\CitationInstaller\
msbuild .\CitationInstaller\CitationInstaller.csproj /t:clean;rebuild /p:Configuration=Release /p:ProductName="%~1 Setup" /p:AsmVersion=%~3 /p:AsmFileVersion=%~3 /p:AsmPublishUrl="%~2%~1.application" /p:AsmTitle=%~1 /p:AsmProduct=%~1
copy .\CitationInstaller\bin\release\setup.exe %~4\%~5\%~1\

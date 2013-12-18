ECHO OFF
CLS
IF NOT "%1"=="" GOTO :Continue
echo .
echo .
echo .
echo usage:    BuildAll [Mode] [Version]
goto :eof

:Continue

set mode=%1
set version=%2
set pubfolder=.\deploy\

echo ******************Building AllSearch52 Started******************
echo .******************^^^^^^^^^^^^^^^^^^^^^^^^^^******************
call .\build AllSearch52 https://secureinstall.us/%mode%/AllSearch52/ %version% %pubfolder% %mode%
echo ******************Building AllSearch52 Ended******************
echo .******************^^^^^^^^^^^^^^^^^^^^^^^^******************

echo ******************Building Fastrank Started******************
echo .
call .\build Fastrank https://secureinstall.us/%mode%/Fastrank/ %version% %pubfolder% %mode%
echo ******************Building Fastrank Ended******************
echo .******************^^^^^^^^^^^^^^^^^^^^^******************

echo ******************Building ListingApe Started******************
echo .
call .\build ListingApe https://secureinstall.us/%mode%/ListingApe/ %version% %pubfolder% %mode%
echo ******************Building ListingApe Ended******************
echo .******************^^^^^^^^^^^^^^^^^^^^^^^******************

echo ******************Building TownCenter Started******************
echo .
call .\build TownCenter https://secureinstall.us/%mode%/TownCenter/ %version% %pubfolder% %mode%
echo ******************Building TownCenter Ended******************
echo .******************^^^^^^^^^^^^^^^^^^^^^^^******************

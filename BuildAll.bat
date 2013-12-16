set version=1.0.5.1
set mode=%1
set pubfolder=pub

echo Building AllSearch52 Started******************
echo .
call .\build AllSearch52 https://secureinstall.us/%mode%/AllSearch52/ %version% %pubfolder%
echo Building AllSearch52 Ended******************
echo .

echo Building Fastrank Started******************
echo .
call .\build Fastrank https://secureinstall.us/%mode%/Fastrank/ %version% %pubfolder%
echo Building Fastrank Ended******************
echo .

echo Building ListingApe Started******************
echo .
call .\build ListingApe https://secureinstall.us/%mode%/ListingApe/ %version% %pubfolder%
echo Building ListingApe Ended******************
echo .

echo Building TownCenter Started******************
echo .
call .\build TownCenter https://secureinstall.us/%mode%/TownCenter/ %version% %pubfolder%
echo Building TownCenter Ended******************
echo .

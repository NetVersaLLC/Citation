set version=1.0.5.1
set mode=%1

echo Building AllSearch52 Started******************
echo .
call .\build AllSearch52 https://secureinstall.us/%mode%/AllSearch52/ %version%
echo Building AllSearch52 Ended******************
echo .

echo Building Fastrank Started******************
echo .
call .\build Fastrank https://secureinstall.us/%mode%/Fastrank/ %version%
echo Building Fastrank Ended******************
echo .

echo Building ListingApe Started******************
echo .
call .\build ListingApe https://secureinstall.us/%mode%/ListingApe/ %version%
echo Building ListingApe Ended******************
echo .

echo Building TownCenter Started******************
echo .
call .\build TownCenter https://secureinstall.us/%mode%/TownCenter/ %version%
echo Building TownCenter Ended******************
echo .


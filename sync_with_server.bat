set OLDPATH=%PATH%
set PATH=C:\Users\jonathan\dev\rsync\bin

cd C:\Users\jonathan\dev\Citation

rsync -avz -e ssh deploy@franklin.netversa.com:/home/deploy/contact/shared/labels .

rsync -avz -e ssh labels deploy@franklin.netversa.com:/home/deploy/contact/shared

set PATH=%OLDPATH%

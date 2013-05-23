set OLDPATH=%PATH%
set PATH="C:\Users\jonathan\dev\rsync\bin";%PATH%

cd C:\Users\jonathan\dev\Citation

rem rsync -avz -e ssh deploy@franklin.netversa.com:/home/deploy/contact/shared/labels .

ssh deploy@franklin.netversa.com 'rm -rf /home/deploy/contact/shared/labels'

rsync -avz -e ssh labels deploy@franklin.netversa.com:/home/deploy/contact/shared

set PATH=%OLDPATH%

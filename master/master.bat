@echo on
@title bat execute git auto commit

cd D:/Git/ABAP/master

git checkout master

set /p var=: 
git add "%var%"
git commit -m   "%var%"

git push origin master

explorer https://github.com/Jack-liangqihua/ABAP/tree/master/master

pause
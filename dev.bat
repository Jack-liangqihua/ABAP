@echo on
@title bat execute git auto commit
cd D:/Git/ABAP
git checkout dev
git add .
git commit -m "commit."
git push origin dev
echo "Batch execution complete!"
pause
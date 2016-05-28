# gitperl dnw

create a new repository on the command line

echo "# gitperl" >> README.md

git init

git add README.md

git commit -m "first commit"  -a   (add -a to skip above "git add" step)

git remote add origin git@github.com:dwitt29/gitperl.git   (for new files, not updated ones)

git push -u origin master


push an existing repository from the command line

git remote add origin git@github.com:dwitt29/gitperl.git

git push -u origin master


#testing update after clone


git clone git@github.com:dwitt29/gitperl.git .   (use clone to pull down a copy from git)


git checkout -b branchname  (for branching)

git status (check which branch you're under)

git add . (add changes done on branch)

git commit -m ""  (commit changes done on branch)

git push -u origin branchname (send updates in branch to github web)


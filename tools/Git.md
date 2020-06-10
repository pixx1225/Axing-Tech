# git
## git基本命令
git status
git log
git init
git remote add url
查看分支：git branch
创建分支：git checkout -b pixingxing
拉取分支：git pull origin release/v10.8.5
添加文件：git add readme.txt 
添加提交：git commit -m "create test"
切换分支：git checkout master
合并分支：git merge dev
删除本地分支：git branch -d pixingxing
删除远程分支：git push origin --delete pixingxing

## 本地分支提交流程
git checkout -b pixingxing
git checkout -b pixingxing origin/master_1.23.6
git add .
git commit -m ‘create xxx'
git push origin pixingxing:remotebranch

## 合并commit
git rebase -i HEAD~3
进入vi模式后，在键盘上敲i键进入insert模式
squash 的意思是这个 commit 会被合并到前一个commit
修改完成后，按esc键，输入:wq进行保存 再:wq。
再次PUSH: git push -f

## cherry-pick
将某个分支的某次提交合并到指定分支
git checkout branch2
git log 复制某次提交的序列号xxx
git checkout branch1
git cherry-pick xxx

## 保留本地的修改同时又把远程的合并过来
- 保存本地修改
git stash  
git pull origin master  
git stash pop  
- 不保留本地修改
git reset --hard 
git pull origin master

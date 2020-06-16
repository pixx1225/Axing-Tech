[TOC]

# Git

## git基本命令
git status  查看仓库当前的状态
git log  查看日志
git init  初始化
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
**保存本地修改方法**

- git stash	保存本地修改

​       git stash list	查看保存信息

- git pull      拉去分支

- git stash apply 0

  或者git stash pop

**git  stash clear** 是清除所有stash

**不保留本地修改**

- git reset --hard 
- git pull

## Fork项目工作流程

1. Fork项目到自己的GitLab

2. git clone [url]

   / 查看远程地址 git reomte -v

   / 修改远程地址 git remote set-url origin [url]

3. git remote add [远程主机名ntp1-u-deal] [中心库url]

   / 查看远程地址 git reomte -v   出现四条url

   ```shell
   ntp1-u-deal    http://gitlab.***/ntp1-u-deal.git(fetch)
   ntp1-u-deal    http://gitlab.***/ntp1-u-deal.git(push)
   origin    http://gitlab.yourname/ntp1-u-deal.git(fetch)
   origin    http://gitlab.yourname/ntp1-u-deal.git(push)
   ```

4. git fetch  [远程主机名ntp1-u-deal]  [分支名master1.10.0]   

5. git merge  ntp1-u-deal/master1.10.0

6. git add .

   git commit -m "..."

   git push origin master1.10.0

7. 进入自己Fork的项目，点击Merge Request，点击新增MR，提交
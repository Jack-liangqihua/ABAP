# ABAP
ABAP

```
1、$ git branch --all
  dev
  master
  origin/dev
  origin/master
  remotes/origin/dev
  remotes/origin/master


2、所有提交皆由本地分支（master , dev）发起，提交到远程分支 （origin/master ,  origin/dev），所有发布皆由主干（remotes/origin/master , remotes/origin/dev ）
 


```


1.	git branch	查看分支
2.	git branch name	新建分支,其中name为分支名称
3.	git checkout name	切换到name分支
4.	git merge name	合并name分支到当前分支
5.	git branch -d name	删除name分支
6.	git push -u name:name1	提交分支name到云端分支name1
7.	git log	查看commit日志
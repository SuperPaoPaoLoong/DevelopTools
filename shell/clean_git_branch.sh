#!/bin/bash
#	清理git历史分支
#	生成清理指定日期内未提交更新的远程分支的命名

clear

read "DATE_PARM?设置日期(yyyy-MM-dd)："

while echo $DATE_PARM|grep -v -Eq '^\d{4}-\d{1,2}-\d{1,2}'
do
read "DATE_PARM?设置日期(yyyy-MM-dd)："
done

## 拉取远程分支，取出名字，过滤关键分支名，存为数组
str=`git branch -r | awk '{FS="/"}{print $NF}'| awk '{FS=" "}{print $NF}'| grep -v -w dev| grep -v -w pre_release| grep -v 'master'|grep -v '^dev\`'|awk -v RS='' '{gsub("\n"," "); print}'`
arr=(`echo ${str}`)


delarr=()
## 检查远程分支最的更新时间，记录小于设置日期的分支名到新数组
for item in ${arr[@]}
do

git checkout $item

itemdate=`git log --date=iso | grep Date|awk 'NR==1'|awk '{print $2}'`


if [[ $itemdate < $DATE_PARM ]]
then

delarr[${#delarr}+1]=$item

fi

git checkout master
git branch -d $item

# break

done

clear
echo "生成删除远程分支代码："
echo "START<<<<<<<"

for it in ${delarr[@]}
do
echo "git push origin --delete $it"
done


echo ">>>>>>>END"


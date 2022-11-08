//do-file for "第1章 Stata软件与Stata的资源"
//Credit to Prof.ZHONG
//Author @Lux

cd "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources"      //更改工作目录    

log using "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\Ch1-Stata_codes"
//生成日志文件，并将其存放在上一级路径下。默认格式.smcl。包括命令和结果，但不包括图形结果。

use Arctic9.dta, clear       //use Arctic9, clear
sum extent
log off     //暂时关闭
sum extent
log on      //恢复使用
log close    //彻底退出

log using "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\Ch1-Stata_codes"    //提示日志已经存在。先删除刚才那个日志文件，然后再生成同样文件名的日志，将日志重新打开
//use Arctic9, clear
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\Arctic9.dta"      
          


des
list     //数据-数据编辑器，或者输入edit
list in 1/10
list extent area in 1/10
sum
sum extent area

corr extent area volume tempN

twoway connect extent year    //线图
//scatter extent year

graph save "Graph" "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\图11.gph"

//如何使用帮助文件，自己补充
help correlate   
help dropmiss     //提示没有，说明不是stata公司开发的命令
findit dropmiss   //用户编写的命令，找到下周链接并安装它
help dropmiss     //此时显示帮助文件

help fre
ssc install fre

sysuse auto
misstable sum     //显示只有rep78变量存在5个缺失值
dropmiss
dropmiss, obs      //(0 observations deleted)

dropmiss, any     //(rep78 dropped)
dropmiss, obs any    // (0 observations deleted)

//重新打开数据，并执行最后一条命令，删除5条记录
sysuse auto, clear
dropmiss, obs any
(5 observations deleted)


//Stata 200 问：常见问题都在这里了-UCLA FAQs
//https://lianxh.cn/news/1c523d15c69f7.html
/*
目录
Stata 常见问题：200 FAQs
Stata 功能导航
Stata 基础
数据导入、导出与转换
Stata 至 HLM
Stata 图形用户界面 (适用于 Windows)
常用分析和数据管理
数据分析基础
缺失值
文字变量
错误信息
时间序列
Stata 与 SAS 和 SPSS 互通
常规统计分析
回归分析
交乘项和组间系数差异比较
回归图
各类回归模型
margins 命令 - 边际效应分析
中介效应
逻辑回归
方差分析
SEM (结构方程模型)
Stata 绘图
高级统计–调查命令和聚类
高级统计-其他
其他
*/

//注意：//与/*   */在添加注释时的差别，//到了下一行时又是可以执行的命令。而/*   */到了下一行时照样处于解释状态。所以，有一个较长的注释时更适合使用。





//do-file for "第2章 数据管理"
//Credit to Prof.ZHONG
//Author @Lux

//2.2创建一个新的数据集
edit    //在数据编辑器内输入图2.1中的数据。注意观察前3个var的类型
rename var2 pop   //在编辑器窗口双击列的标题，然后在启动的对话框中键入新变量名
label variable pop "Population in 1000s, 1995"         //还可以进一步为变量名添加标签，这是可选项。Population in 1000s, 1995
save "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\Canada.dta"

des
list

label data "Canadian dataset 1"    //为数据集添加说明，可选


use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\Canada1.dta", clear   //调出已经准备好的数据
//cd "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources"
//use Canada1, clear
sort pop
order place unemp mlife flife pop      //控制数据集内变量的顺序
edit

//2.4定义数据的子集：in和if选择条件
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\global1.dta", clear
//cd "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources"
//use global1

des

list in 1/5
sort temp
list in -10/l      //根据temp从低到高排序，然后列出倒数第10条到最后一条观测案例

sum temp if year<1970
sum temp if year>=1970
sum temp if ( month==1 | month==2) & year>=1940 & year<1970


//关于missing，书中p24，提到一句话，可能意思表达反了：就那些在age、income和education上包括缺失值的观测案例对vote进行列表。觉得应该是“不包括”
//missing()        returns 1 (meaning true) if any of its arguments, numeric or string, evaluates to missing and 0 (meaning false) otherwise.
//  missing(x1,x2,...,xn)            Description:  1 if any of the arguments evaluates to missing; otherwise, 0
//missing()函数，如果有缺失，返回1，没有，则返回0
//用下面的语句来验证
sysuse auto
misstable sum
edit
tab foreign if missing(rep78)==0    //就rep78上不包括缺失值的观测案例对foreign进行列表统计
tab foreign if !missing(rep78)       //与上一句结果一样，如果rep78不存在缺失，则对这些不缺失的观测，按照foreign变量进行列表统计
tab foreign if rep78<.             //缺失代表着极大的数，<.  就代表着排除缺失


drop make price
drop in 12/13               //错误的命令：drop temp in 12/13
keep mpg rep78 headroom     //仅仅是简化变量，不会影响到数据文件，除非将这些变量进行保存。


//2.5创建和替代变量
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\Canada1.dta", clear
gen gap= flife- mlife
label variable gap "Female-male life expectancy gap"
des gap
list place flife mlife gap

format gap %4.1f         //调整数据显示格式
//list place flife mlife gap

//对place变量进行重新分类，生成一个新的分类变量,
gen type=1
replace type=2 if place=="Yukon" | place =="Northwest Territories"
replace type=3 if place=="Canada"    //其他的地区不做修改，取值就是1
label variable type "Province, territory or nation"    //添加变量标签
list        //type显示的结果是1、2、3

//添加数值标签，即为变量的取值1、2、3添加说明
label define typelbl 1 "Province" 2 "Territory" 3 "Nation"
label value type typelbl
list

//2.6缺失值编码
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\Granite2011_6.dta" 
tab genint
tab genint, nolabel    //只显示变量的取值，而不是标签
fre genint

//含有缺失值时如何正确地进行描述统计：将98、99重新编码为缺失值再汇总
tab educ, sum( genint)     //按照educ的分类对genint变量进行概要统计，结果不正确
gen genint2=5- genint if genint<90   //反向编码
replace genint2=.a if genint==98
replace genint2=.b if genint==99    //定义为缺失值就可以不参与运算
list genint genint2    //genint2还没有添加数值标签，可以继续使用过去的数值标签，但是过长，希望缩减长度

label variable genint2 "Interest in 2012 elections (new)"
label define genint2lbl 1 "Not very" 2 "Somewhat" 3 "Very" 4 "Extremely" .a "DK" .b "NA"     //定义数值标签的内容时取了一个稍稍不同的名字genint2lbl，好理解一点
label values genint2 genint2lbl
list genint genint2

tab genint genint2, miss    //二维交叉表，包含缺失值，目的是判断上述过程是否正确
tab educ, sum( genint2)

//专门命令mvdecode，把数值表示的缺失值改回以.表示的缺失值。翻译书中p28
//mvdecode *, mv(-999)      //把以数值-999改回缺失值。或者  mvdecode _all, mv(-999)
//mvdecode genint income age, mv(97=. \ 98=.a \ 99=.b)    //把这三个变量中以97、98、99表示的缺失值分别改成对应的缺失值形式
mvdecode genint, mv(98=.a \ 99=.b)
tab educ, sum( genint)     //这一结果与书中不同，原因是genint2做了反向编码

//更简单的方法，用recode命令
recode genint (98=.a) (99=.b)

//2.7使用函数
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\global1.dta", clear
gen edate=mdy(month, 15, year)    //返回的是天数，day用15天代替
label variable edate "elapsed date"
list in 1/5
format edate %tdmCY     //显示月、世纪、年份
list in 1/5

//绘制时间序列图
sort year month
order year month edate
twoway line temp edate
//line temp edate
//twoway connected temp edate

di log10(10^83)
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\Arctic9.dta", clear
sum extent
di r(mean)
gen exten0= extent-r(mean)
sum extent exten0
return list     //返回了extent0的结果
sum extent
return list      //返回了extent的结果

egen zextent=std(extent)
gen e1=(extent-r(mean))/r(sd)     //都是缺失值，因为最后一步不是sum
sum extent     //如果sum extent之后，先把e1给drop了，再执行gen e1=(extent-r(mean))/r(sd) 同样都是缺失值
gen e2=(extent-r(mean))/r(sd)

//比较gen和egen，翻译书，p31
/*inputting data manually for the egen command use*/
clear
input var1 var2 var3 var4
4 . 2 1
3 2 3 .
5 3 5 3
4 4 4 3 
5 5 5 5
end
gen avg=(var1+var2+var3+var4)/4         //有缺失时该条记录的结果也是缺失
list
egen avg2=rowmean(var1 var2 var3 var4)       //根据实际有的数值个数计算均值
list

/*inputting new data manually*/
clear
input var1 var2 var3 var4
4 . 2 1
3 2 3 .
5 3 5 3
4 4 4 . 
5 5 5 5
end
egen tot=rowtotal(var1 var2 var3 var4)      //计算行合计，缺失值当作0
list

use "D:\上课\003学硕\《应用STATA做统计分析》(8版)数据\PKZIP格式  sws12\Arctic9.dta", clear
egen extentrank=rank(extent)      //返回变量的排序
sort extent

//2.8数值和字符串之间的格式转换
use "D:\上课\003学硕\《应用STATA做统计分析》(8版)数据\PKZIP格式  sws12\Canada2.dta", clear
list place type         //type显示的是字符（蓝色字体），是标签，点击该单元格，将显示背后的数字，所以是数值型变量
list place type, nolabel        //只显示数值  

encode place, gen(placenum)     //依据字符串变量创建一个添加了取值标签的数值型变量。按字母顺序赋值
//如果type是字符串，显示的是Nation等字符，可以通过encode命令将其转化为带有数值标签的数值型变量

decode type, gen(typestr)       //使添加了取值标签的数值型变量的取值创建字符串变量
encode typestr, gen(type1)      //type1就是带有数值标签的数值型变量

list place placenum type typestr      //与原先的变量在显示上是一样的，但添加了nolabel就显示差异
list place placenum type typestr, nolabel
sum place placenum type typestr   //字符串不参与计算

//tab type, gen(typeD)       //产生虚拟变量的常用方法，2.9节讲到
//edit

//2.9创建新的分类变量和定序变量
use "D:\上课\003学硕\《应用STATA做统计分析》(8版)数据\PKZIP格式  sws12\Canada2.dta", clear
tab type, gen(type)   //创建3个虚拟变量,将分类变量重新表达成一组虚拟变量
des
list place type*
//list place type type1-type3

//根据均值大小生成2个虚拟变量
sum unemp if type!=3
drop if type==3    //删除了整个类型=3的记录
di r(mean)  //不显示结果
sum unemp   //重新概况统计，目的是取出均值，没有这一条下面两条语句结果不正确
gen unemp2=0 if unemp<r(mean)
replace unemp2=1 if unemp>=r(mean) & !missing(unemp)

//生成定序变量
gen unemp3=autocode(unemp, 3, 5, 20)    //使unemp从5到20的取值区间分成等宽的三组
list place unemp unemp3

//2.10标注变量下标
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\global2.dta", clear
gen caseid=_n      //_n表示观测案例的序号，是个变量
order caseid
ed
sort temp      //以另一种方式对数据进行排列，但caseid的取值已经固定
sort caseid     //恢复原来的顺序

di temp[4]     //变量名添加下标表示该变量特定的观测案例的序号

gen diftemp=temp[_n]-temp[_n-1]    //temp或temp[_n]表示第n条观测案例的取值，temp[_n-1]表示前一条观测案例的取值
gen diftemp2=temp-temp[_n-1]
ed

//2.11导入其他程序的数据
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\snowfall.xls", clear     //错误
import excel "D:\上课\003学硕\《应用STATA做统计分析》(8版)数据\PKZIP格式  sws12\snowfall.xls", sheet("Berlin") cellrange(A4:O56) firstrow clear    
//手动导入最方便

//读入文本文件MEI.raw，可用记事本打开，数值以制表符进行分割
insheet using d:\MEI.raw, tab name clear    //命令输入。tab表示制表符。comma表示逗号形式分割数据。'
import delimited "D:\上课\003学硕\《应用STATA做统计分析》(8版)数据\PKZIP格式  sws12\MEI.raw", clear    //手工导入文本数据格式

//2.12合并两个或多个Stata文件
use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\lakewin1.dta", clear
des
list in -4/l    //倒数第4个到最后一个

use "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\lakewin2.dta", clear
des
list
append using "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources\PKZIP格式  sws12\lakewin1.dta"    //将旧信息与新信息合并，属于观测案例添加，不要求两个数据集包括相同的变量，只存在于一个数据集的变量，合并后会出现缺失。
ed
sort year
list in -7/l

//merge属于加宽（添加变量），append属于加长（添加观测案例）
cd "D:\上课\003学硕\《应用STATA做统计分析》(8版)数据\PKZIP格式  sws12\"
use lakesun, clear
des
merge 1:1 year using lakewin3
ed
drop _merge
sort year
list in 1/4
list in -4/l

//补充：p45提到两个数据集都已经按照year做了排序，否则在合并之前必须sort year，事实上合并之前不需要按照合并变量year进行排序
use lakesun, clear
sort sunout     //打乱排序
ed
merge 1:1 year using lakewin3    //照样能合并，且按照year自动排序

//补充：merge,第一个数据与第二个数据包括相同的变量v2_14，主数据集的那些被留下，调用数据中的被忽略。
/*inputting new data manually*/
clear
input id v1_14 v2_14
1 3 5
2 4 5
3 2 3
4 1 2
5 1 2
6 6 6
end
save d:\data14,replace
clear
input id v1_15 v2_14
1 4 5
2 5 5
3 3 4
4 2 3
5 2 3
end
save d:\data15,replace
clear
/*merging data*/
use d:\data14,clear
merge 1:1 id using d:\data15
//merge 1:1 id using d:\data15, update        //主数据集中出现的任何缺失值由调用数据集中相应的非缺失值进行替代。

//2.13数据分类汇总
//数据结构重组，将12个月份压缩为1年
use global2, clear
ed
collapse (mean) temp, by(year)              //12个月份数据求平均得到1个年份数据
twoway spike temp year

//将10年，每年12个月的数据压缩为1个
use global2, clear
gen decade=10*int(year/10)
ed
statsby, by( decade) clear: sum temp
graph bar max if decade <2010, over(decade)
//graph bar max if year<2010, over(decade)      //执行不了，year not found

//2.14重组数据结构
use MEI0, clear
ed
des
list year-mei7 in 1/5
reshape long mei, i(year) j(month)    //将宽格式变形为长格式，
compress
sort year month
des
ed

//复习merge命令，并画图
use global2, clear
merge 1:1 year using mei1      //variable year does not uniquely identify observations in the master data
merge 1:1 year month using mei1

use global3, clear
twoway line temp edate || line mei edate, yaxis(2) lpattern(dash) || if year>1949, legend(row(2))
//将mei放置在右边的y轴，yaxis(2),且被画出dash线型。将图列设置成2行，而不是默认的2列
//twoway line temp edate || line mei edate, yaxis(2) lpattern(dash) || if year>1949

use global3, clear
drop edate
reshape wide mei temp, i(year) j(month)

//2.15使用权数
use Nations2, clear
sum life
sum life [fweight=pop]

//2.16生成随机数据和随机样本
clear
set obs 10
set seed 12345
gen randnum=runiform()
list    //跟书中结果不一样，但是我两次操作结果一样

//补充：如何产生随机样本
见1.1上网.do文件

//模拟掷一个六面筛子
set obs 1000
gen roll=ceil(6*runiform())
tab roll

gen dice=ceil(6*runiform())+ceil(6*runiform())
tab dice

clear
set obs 5000
gen index=_n      //不是已经讲过了吗
sum

clear
set obs 2000
gen z=rnormal()
gen u=rnormal(500,75)
sum

clear
drawnorm z, n(5000)
sum

mat C=(1, 0.4, -0.8\ 0.4, 1 ,0 \-0.8, 0 , 1)
drawnorm x1 x2 x3, mean(0, 100, 500) sds(1, 15, 75) corr(C)
sum x1-x3
corr x1-x3

//2.17编制数据管理程序
//如何处理长命令
use global3, clear
twoway line temp edate ///
|| line mei edate, yaxis(2) lpattern(dash) ///
|| if year>1949, legend(row(2))
/*上述命令不能拷贝到命令窗口执行，但可在do文件编辑器内运行。
在do文件中使用///的目的是将长的命令连接在一起，确保其能被正常执行。
这是因为Stata通常把一条命令行的结尾视为该命令的结束。如果一个一个命令行太长，一行内放不下，可以用///告诉stata此命令持续至下一行。
该命令只有在达到不以///结尾的那一行之后才会结束。*/

/*处理长命令方法2      #delimit ;    
设定英文分号;作为一行命令结束的分隔符。接着键入一条直到分号出现才结束的长命令，然后将分隔符重新设定回其常规状态，即回车(cr) */
use global3, clear
#delimit ;
twoway line temp edate 
|| line mei edate, yaxis(2) lpattern(dash) 
|| if year>1949, legend(row(2)) ;
#delimit cr







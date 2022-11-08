//do-file for "第3章 制图"
//Crefit to Prof.ZHONG
//Author @Lux

cd "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources"

//3.2直方图
use Nations2, clear
des
hist adfert    //默认density
hist adfert, percent    //由于直方条和x轴的刻度并不对应，很难具体地描述该图

hist adfert, frequency start(0) width(10) xlabel(0(20)200) xtick(10(20)210) ylabel(0(5)35, grid gmax) title("Adolescent in 194 nations")
hist adfert, frequency start(0) width(10) xlabel(0(20)200) xtick(10(20)210) ylabel(0(5)35, grid gmax)  //xlabel显示坐标轴数值标签，xtick显示坐标刻度
hist adfert, frequency start(0) width(10) xlabel(0(20)200) ylabel(0(5)35, grid gmax)
hist adfert, frequency start(0) width(10) xlabel(0(20)200) ylabel(0(5)35)     //够用
hist adfert, frequency start(0) width(10)        //最实用

hist adfert, percent start(0) width(10) by( region, total)    //针对region的每一个取值分别作图，最后一个图是所有数据的结果

//3.3箱线图
cd "C:\Users\llx\Desktop\量化分析教材\《应用STATA做统计分析》(8版)数据\PKZIP格式_Statistics_with_Stata_12_data_sources"
use Nations2, clear
graph box adfert   //graph不可省
graph box adfert, marker(1, mlabel(country)) ytitle("Births per")  
/*marker(1)指向被设定的第一个变量，标记出其异常值。以country的值作为标签将异常值标识出来。ytitle为y轴设定一个标题。
 marker(#, marker_options  marker_label_options)       look of #th marker and label for outside values
*/

graph box life literacy , marker(1, mlabel(country)) marker(2, mlabel(country))
//尝试将两个变量画在同一个图中，并分别标出异常值

sum adfert, detail
graph box adfert, marker(1, mlabel(country)) yline(39.35) over(region)   //对分类数据分别绘制箱线图

/*graph box y1 y2, over(cat_var)
y1, y2 must be numeric; statistics are shown on the y axis. cat_var may be numeric  or string; it is shown on categorical x axis
*/
graph box life literacy , over( region )    //按照分类数据对两个变量分别绘制箱线图
graph box life literacy , by( region )     //by(region)是在5个小窗口分别画出各个箱线图，而不像over那样在一幅图中画出5个箱线图

//3.4散点图和叠并
use Nations2, clear
scatter life school     //twoway scatter life school      //graph twoway scatter life school
scatter life school, mlabel( country)    //以country的值作为标签
scatter life school, msymbol(o) mcolor(purple)   //msymbol()控制点的形状，mcolor()控制点的颜色

scatter life school [fweight=pop], msymbol(Oh)     //使得数据点与各国的人口数成比例

//graph twoway族的一个功能是可以叠并两幅或更多幅图, ||
scatter life school , msymbol(Oh)
lfit life school, lwidth(medthick)     //不能执行命令，too many variables specified
/*  lfit is an out-of-date command as of Stata 9.  lfit has been replaced with the estat gof command
twoway lfit yvar xvar [if] [in] [weight] [, options]  */

twoway scatter life school || lfit life school
scatter life school , msymbol(Oh) || lfit life school, lwidth(medthick)    //一起看散点图和回归线

graph twoway scatter life school , msymbol(Oh) ///
|| lfit life school, lwidth(medthick) ///
||, ylabel(45(5)85) xlabel(2(2)12) xtick(1(2)12) legend(col(1) ring(0) position(11))
//col(1)是1、2的1，表示图例的显示在一列内。ring(0),也是数值，表示图例放置在绘图区内部还是外部。position(11)指图例放在11点钟位置

//3.5曲线标绘图和连线标绘图
use Arctic9, clear
line area year    //线图,它看不到数据点，而connect则能够看到   //twoway connect area year
line area extent year, xlabel(1980(5)2010) lwidth(medium medthick) lpattern(solid dash) ylabel(0(1)8)
//简化命令，area变量被绘成一条宽度为medium且样式为solid的曲线，extent变量被绘成一条宽度为medthick且样式为dash的曲线
line area extent year, lpattern(solid dash)     //已经够用

//3.6其他类型的二维标绘图

//3.7条形图和饼图
use Nations2, clear
gen gdp1000=gdp/1000
sum gdp gdp1000
graph bar (mean) gdp1000 (median) gdp1000, over(region) bar(1, color(blue)) bar(2, color(orange))
//描绘gdp1000在region不同取值上的均值和中位数。柱子1为蓝色，2为橙色。

//3.8对称图和分位数图
use Nations2, clear
hist femlab, norm percent
symplot femlab   //对称图，以高于中位数和低于中位数制图。如果分布是对称的，则所有的点都将位于对角线上

quantile femlab
quantile femlab, xlabel(0(0.1)1,grid) ylabel(0.2(0.1)1,grid)

qnorm femlab, grid
















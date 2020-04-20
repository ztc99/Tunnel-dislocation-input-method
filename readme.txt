main.m为GUI程序的输入界面，计算完成后得到disp.inp文件。
zidong.m与main.m程序作用相同，但无界面化，在脚本内直接修改参数亦可计算得到disp.inp文件。
其他.m和.fig文件均为main.m的脚本和子界面。

edgrn-zidong.exe和edcmp-zidong.exe分别为格林函数计算程序和同震变形场计算程序，已进行封装，参考代码见Wang RJ. 1999. A Simple Orthonormalization Method for Stable and Efficient [J]. Computers & Geosciences, 89(3) :733-741. 

coord_point_suidao.rpt为存储abaqus模型中边界节点坐标的文件，四列分别存储了节点编号、xyz坐标值；
dyl.inp为平衡地应力所需文件，存储了边界各节点上地应力导致的节点反力，获取方法繁多，请自行网上查阅。

suidao.cae为算例模型，此处需先在作业中进行地应力计算，运行作业suidao-DYL-S4R，再运行作业tanxingsuidao，也可自行选用其他方法平衡地应力。

其他关于程序使用的疑问可发邮件至1280340163@qq.com.

ztc
2020/04/20

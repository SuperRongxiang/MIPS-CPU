# MIPS-CPU
一个简单的MIPS CPU，使用verilog语言编写。 目前它拥有如下特性： 
1.经典的五阶流水线设计：取指，译码，计算，数据存储器访问，写回。 
2.能够处理四种基本的中断异常 
3.拥有32位FPU，能够执行单精度浮点数的加减乘除指令。 
4.尝试实现了双线程，两个线程公用FPU，提高利用率。 
5.采用了局部两级动态预测器对分支指令跳转进行预测。
6.采用了使用LRU替换算法的BTB对分支指令地址进行预测。
还在不断地改进中，下一步计划加入乱序发射等新特性。
未来将其改为支持部分RISC-V指令集（RV32IMF）的CPU。

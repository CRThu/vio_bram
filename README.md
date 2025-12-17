# FPGA VIO-BRAM 在线读写调试工程    
本工程基于 Xilinx Vivado 平台，封装了一个双端口 BRAM 模块，通过 VIO (Virtual Input/Output) 实现对 Block RAM 存储内容的在线读写监控。这种方案无需编写复杂的 UART 或 AXI 总线协议，即可通过 Tcl 脚本直接操作硬件内存数据。    

## 功能特性 
双端口透明访问：主逻辑使用 Port A，调试端口 Port B 挂载在 VIO 上 。     
脚本化在线读写：提供 Tcl 脚本自动遍历 BRAM 地址空间，支持 .csv 或 .coe 格式的数据导入与回读。   
自动化环境：根目录集成 runme.bat 与 runme.ps1，支持一键处理环境编码并启动调试任务 。    

## 目录结构 

├── script/               # 存放核心 Tcl 脚本及中间文件 
├── *.srcs/sources_1/new  # HDL 源代码  
│   ├── top.v             # 顶层例化模块    
│   └── bram_top.v        # BRAM 与 VIO 封装层  
├── runme.bat             # 入口    
└── runme.ps1             # powershell入口  

## 使用指南 
硬件生成： 
生成真双端口BlockRAM ip核。     
在 Vivado 中工程例化了 vio_bram_b 和 blk_mem_gen_0 IP 核， 并使用bram_top替代原先使用的bram ip核。  
生成 Bitstream 并下载至开发板。     

Tcl修改:
修改vio.bram.w.tcl/vio.bram.r.tcl的vio和probe为你使用的名称。   

数据准备： 
现有coe可运行时拖入文件至控制台转换为csv。  
或可将待写入的 HEX 数据存放在 ./script/temp/coe_out.csv。   

运行脚本：
根目录下的 runme.bat 。     
或者在 Vivado Tcl Console 中直接执行：  

```Tcl
source ./script/vio.bram.w.tcl   # 写入数据
source ./script/vio.bram.r.tcl   # 回读数据
```


---

*本README由Gemini生成*
# CDC-handshake-signal
多bit数据 跨时钟域握手信号处理方法
包含两种处理方法HDL代码：完全握手信号，部分握手信号
原则上来说，完全握手信号不受时钟快慢限制，可以稳定进行数据传输，但是部分握手信号是有限制的。

1、mutidata_sync：完全握手信号，示意图如下，代码由iverilog编译+仿真波形由GTKwave产生。

![image](https://user-images.githubusercontent.com/72872077/193496567-263ce0ec-cd8e-4297-b80d-e8b27692bcde.png)   ![image](https://user-images.githubusercontent.com/72872077/193497076-f0a7018e-113b-4025-8032-8683db9de1d9.png)


2、mutidata_2：部分握手信号，有两种结构。一种是输入电平请求输出脉冲响应，另一种是输入输出均为脉冲响应。


![image](https://user-images.githubusercontent.com/72872077/193595429-722044ae-78fa-4ad7-b081-5cae7d62b380.png) 

![image](https://user-images.githubusercontent.com/72872077/193595617-39125ba1-2f9d-4682-a7b1-8b5629f8e2a3.png)

3、mutidata_3：部分握手信号，脉冲响应。
![image](https://user-images.githubusercontent.com/72872077/194084639-f82e607d-d023-4de5-86a1-54ebc52351c1.png)
![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/88919488-e3ae-4e68-937a-06d2e91d908e/Untitled.png)

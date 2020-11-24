SE16N 添加修改、删除表数据权限
1. Goto SE16N

2. Input &SAP_EDIT in command field, and press ENTER

3. 直接删除不需要的数据

注意：&SAP_EDIT方法在产品版本EHP5之后不好用，SAP通过一个notes取消了&SAP_EDIT功能。

产品版本可以在系统状态中找到。





但是我们还是可以通过debug改值的方式把se16n的编辑状态调出来，

命令栏输入/h后回车，然后点击运行进入debug模式，



将GD-SAPEDIT和GD-EDIT的值都改为大写‘X’，然后F8



最后可以看到除了主键都变成可编辑单元格了。
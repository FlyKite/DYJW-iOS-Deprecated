# ![Logo](https://raw.githubusercontent.com/FlyKite/DYJW-iOS/master/DYJW/Assets.xcassets/AppIcon.appiconset/appIcon-76.png)东油教务 iOS App
An iOS application for students of NEPU to use the JiaoWuGuanLi system on iPhone.  
iPhone上的东北石油大学教务管理系统。  

APP站点：<http://dyjw.fly-kite.com/>   
源代码在GPLv3协议下发布

工作原理
---
东油教务APP使用AFNetworking模拟用户登录教务管理系统并使用OCGumbo对页面源码进行解析以获取需要的信息，如成绩和课表等等。

安全性
---
东油教务仅仅模拟用户登录，并非对学校教务管理系统的数据库直接进行操作，因此对教务管理系统的危害为零。  
东油教务不会将用户密码上传至服务器（我的阿里云服务器），但是会将密码保存在手机本地（功能需要），请用户自行保管好手机以免账号被盗。

捐赠
---
东油教务使用阿里云服务器，以及发布到App Store需要支付开发者账号费用  
如果觉得APP做得还不错，请投币至支付宝DogeFlyKite@gmail.com  

协议
---
```
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

Copyright (C) 2015 Doge Studio

This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under certain conditions.
```

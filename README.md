基石手机客户端开发文档
一 开发环境
使用flutter和android studio开发
1)flutter 1.9.1+hotfix.5 
2) dart 2.5.0
3) android studio 3.4.1

1 android 相关
1) jre 1.8.0
2) android sdk 28.0

2 ios相关
xcode 10.1

二 工程目录结构
1 发布相关，根目录下
funds.mobileprovision   ios发布证书
funds-release.keystore  android打包证书
funds-release-key.jks 
publish.sh              mac系统下打包脚本，ipa跟apk文件会发布在publish目录下

pubspec.yaml            项目配置文件，资源，版本号，使用第三方插件等

2 原生代码相关，根目录下
ios                     ios工程目录
android                 android工程目录

3 flutter代码相关，lib目录下为flutter程序业务代码
lib下代码结构
main.dart               flutter程序入口类文件
common目录               通用工具代码集合
common/constants.dart   全局常量数据

model目录                业务数据类目录
network目录              通讯相关代码
network/http_request.dart 使用dio插件封装的http通讯基类

pages目录                一级页面相关代码
pages目录下相关说明
一级页面入口
pages/my.dart             我的页面
pages/trial.dart          体验页面
pages/funds.dart          策略页面
pages/home.dart           首页页面
pages/trade.dart          交易页面
pages/trade目录           交易页面相关业务功能类  
pages/trial目录           体验页面相关业务功能类    

routes目录                二级以上路由页面
routes/recharge目录       充值页面相关
routes/contract目录       合约相关
routes/account目录        用户相关，注册登录等
routes/my目录             我的页面二级页面相关
routes/trade目录          交易页面二级页面相关
routes/mail目录           邮件相关

4 屏幕适配说明
common/constants.dart下名为a的类为适配，为简化代码特命名为a
当代码中使用到像素单位时使用a相关属性或方法代替，使用方法如下：
假设使用n像素
当n <= 50时，使用a.n或者a.p(n)代替
当n > 50时，使用a.p(n)代替
示例：
一般代码：
Container(
    margin: EdgeInsets.all(10),
    child: Row(
      children: <Widget>[
        Text('test', style: TextStyle(fontSize: 36, color: Colors.white),),
        SizedBox(width: 100),
        Text('test2', style: TextStyle(fontSize: 50, color: Colors.white),),
      ],
    ),
);

适配代码：
Container(
    margin: EdgeInsets.all(a.px20),
    child: Row(
      children: <Widget>[
        Text('test', style: TextStyle(fontSize: a.px36, color: Colors.white),),
        SizedBox(width: a.px(100)),
        Text('test2', style: TextStyle(fontSize: a.px50, color: Colors.white),),
      ],
    ),
);
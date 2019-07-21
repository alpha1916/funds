import 'package:flutter/material.dart';
import 'common/constants.dart';
import 'common/utils.dart';
import 'common/custom_dialog.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/model/account_data.dart';

import 'package:package_info/package_info.dart';

import 'pages/home.dart';
import 'pages/my.dart';
import 'pages/trade.dart';
import 'pages/trial.dart';
import 'pages/funds.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
//    primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: CustomColors.background1,
    ),
    home: App(),
    debugShowCheckedModeBanner: false
  ));
}

class NavigationIconView {
  BottomNavigationBarItem item;
  final String dir = 'assets/navigation_bar/';
  NavigationIconView({String title, String iconName, String activeIconName}) {
    final double iconSize = a.px22;
    final Widget icon = Image.asset(dir + iconName + '.png', width: iconSize, height: iconSize);
    final Widget activeIcon = Image.asset(dir + activeIconName + '.png', width: iconSize, height: iconSize);
    item = new BottomNavigationBarItem(
        icon: Container(child: icon, padding: EdgeInsets.only(bottom: a.px5),),
        activeIcon: Container(child: activeIcon, padding: EdgeInsets.only(bottom: a.px5),),
        title: Text(title),
        backgroundColor: Colors.blue,
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<Widget> _pages;
  List<NavigationIconView> _navigationIconViews;
  int _currentIndex = 0;
  bool _hacked = false;
  bool _initialized = false;

  final viewDataList = [
    ['首页', 'ic_home_unchecked', 'ic_home_checked'],
    ['体验', 'ic_experience_unchecked', 'ic_experience_checked'],
    ['配资', 'ic_market_unchecked', 'ic_market_checked'],
    ['交易', 'ic_deal_unchecked', 'ic_deal_checked'],
    ['我的', 'ic_me_unchecked', 'ic_me_checked'],
  ];

  _adaptHack() async{
    print('_adaptHack');
    await Future.delayed(Duration(milliseconds: 10));
    _hacked = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(!_hacked){
      _adaptHack();
      return Container();
    }
    if(!_initialized)
      appInit(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      fixedColor: Colors.black87,
      items: _navigationIconViews.map((NavigationIconView view) {
        return view.item;
      }).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize : a.px11,
      unselectedFontSize : a.px11,
      onTap: tabSwitcher,
    );
  }

  tabSwitcher(int index) {
    //交易界面先判断是否登录状态,非登录状态要先登录
    if(index == AppTabIndex.trade && Utils.needLogin())
      return;

    setState(() {
      _currentIndex = index;
    });
  }

  void appInit(context) {
    print('app init');

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//      String appName = packageInfo.appName;
//      String packageName = packageInfo.packageName;
//      String version = packageInfo.version;
      Global.version = packageInfo.version;
    });

    Global.buildContext = context;
    Utils.init(context, tabSwitcher);
    HttpRequest.init(context);
    CustomDialog.init(context);
    Size size = MediaQuery.of(context).size;
    a.init(size.width, size.height);

    AccountData.getInstance().getLocalToken();

    _navigationIconViews = viewDataList.map((list) {
      return NavigationIconView(
        title: list[0],
        iconName: list[1],
        activeIconName: list[2],
      );
    }).toList();


    _pages = [
      HomeView(),
      TrialView(),
      FundsView(),
      TradeView(),
      MyView(),
    ];

    _initialized = true;
  }
}

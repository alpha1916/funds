import 'package:flutter/material.dart';
import 'common/constants.dart';
import 'common/utils.dart';
import 'common/alert.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/model/account_data.dart';

import 'pages/home.dart';
import 'pages/my.dart';
import 'pages/trade.dart';
import 'pages/trial.dart';
import 'pages/funds.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
//    primarySwatch: Colors.blue,
      primaryColor:Colors.white
    ),
    home: App(),
  ));
}

class NavigationIconView {
  BottomNavigationBarItem item;
  final String dir = 'assets/navigation_bar/';
  NavigationIconView({Key key, String title, String iconName, String activeIconName}) {
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
  List<NavigationIconView> _navigationViews;
  int _currentIndex = 0;
  BottomNavigationBar _navigationBar;
  bool initialized = false;

  final viewDataList = [
    ['首页', 'ic_home_unchecked', 'ic_home_checked'],
    ['体验', 'ic_experience_unchecked', 'ic_experience_checked'],
    ['配资', 'ic_market_unchecked', 'ic_market_checked'],
    ['交易', 'ic_deal_unchecked', 'ic_deal_checked'],
    ['我的', 'ic_me_unchecked', 'ic_me_checked'],
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    if(!initialized)
      appInit(context);
//    HttpRequest.realWidth = MediaQuery.of(context).size.width;

    _navigationBar = BottomNavigationBar(
      fixedColor: Colors.black87,
      items: _navigationViews.map((NavigationIconView view) {
        return view.item;
      }).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize : a.px11,
      unselectedFontSize : a.px11,
      onTap: tabSwitcher,
    );
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _navigationBar,
    );
  }

  tabSwitcher(int index) {
    //交易界面先判断是否登录状态,非登录状态要先登录
    if(index == 3 && Utils.needLogin())
        return;

    setState(() {
      _currentIndex = index;
    });
  }

  void appInit(context) {
    Utils.init(context, tabSwitcher);
    HttpRequest.init(context);
    CustomAlert.init(context);
    a.init(MediaQuery.of(context).size.width);

    AccountData.getInstance().getLocalToken();


    //
    _navigationViews = viewDataList.map((list) {
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

    initialized = true;
  }
}

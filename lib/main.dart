import 'package:flutter/material.dart';
import 'common/constants.dart';
import 'package:funds/network/http_request.dart';

import 'pages/home.dart';
import 'pages/my.dart';
import 'pages/trade.dart';
import 'pages/trial.dart';
import 'pages/funds.dart';

void main() {
  HttpRequest.init();
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
    final double iconSize = CustomSize.navigationBarIcon;
    final Widget icon = Image.asset(dir + iconName + '.png', width: iconSize, height: iconSize);
    final Widget activeIcon = Image.asset(dir + activeIconName + '.png', width: iconSize, height: iconSize);
    item = new BottomNavigationBarItem(
        icon: Container(child: icon, padding: EdgeInsets.only(bottom: 5),),
        activeIcon: Container(child: activeIcon, padding: EdgeInsets.only(bottom: 5),),
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
//  PageController _pageController;
  List<Widget> _pages;
  List<NavigationIconView> _navigationViews;
  int _currentIndex = 0;
  BottomNavigationBar _navigationBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final viewDataList = [
      ['首页', 'ic_home_unchecked', 'ic_home_checked'],
      ['体验', 'ic_experience_unchecked', 'ic_experience_checked'],
      ['配资', 'ic_market_unchecked', 'ic_market_checked'],
      ['交易', 'ic_deal_unchecked', 'ic_deal_checked'],
      ['我的', 'ic_me_unchecked', 'ic_me_checked'],
    ];

    _navigationViews = viewDataList.map((list) {
      return NavigationIconView(
        title: list[0],
        iconName: list[1],
        activeIconName: list[2],
      );
    }).toList();

//    _pageController = PageController(initialPage: _currentIndex);
    _pages = [
      HomeView(),
      TrialView(),
      FundsView(),
      TradeView(),
      MyView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    HttpRequest.realWidth = MediaQuery.of(context).size.width;

    _navigationBar = BottomNavigationBar(
      fixedColor: Colors.black87,
      items: _navigationViews.map((NavigationIconView view) {
        return view.item;
      }).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize : CustomSize.navigationBarFontSize,
      unselectedFontSize : CustomSize.navigationBarFontSize,
      onTap: (int index) {
        setState(() {
//          print('click tab:$index');
          _currentIndex = index;
//          _pageController.jumpToPage(_currentIndex);
        });
      },
    );
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _navigationBar,
    );
  }
}

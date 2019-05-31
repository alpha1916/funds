import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'login_input_view.dart';
import 'register_input_view.dart';

//class LoginPage extends StatefulWidget {
//  @override
//  _LoginPageState createState() => _LoginPageState();
//}

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final realWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('登录注册'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10,),
          Center(child: Image.asset(CustomIcons.iconText, width: realWidth * 0.4,)),
          SizedBox(height: 10,),
          _InputView(),
        ],
      ),
    );
  }
}

class _InputView extends StatefulWidget {
  @override
  __InputViewState createState() => __InputViewState();
}

class __InputViewState extends State<_InputView>
with SingleTickerProviderStateMixin{
  final _titles = ['登录', '注册'];
  int _currentIndex = 1;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: _titles.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if(_currentIndex != _tabController.index){
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    _tabController.index = _currentIndex;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:Container(
        child: Column(
          children: <Widget>[
            _tabBar(),
            _tabBarView(),
          ],
        ),
      )
    );
  }

  Widget _tabBar() {
    return TabBar(
      tabs: _titles.map((title) {
        return Text(title);
      }).toList(),
      controller: _tabController,
      indicatorColor: CustomColors.red,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: false,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      indicatorWeight: 3.0,
      labelStyle: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 17, height: 1.5),
    );
  }

  Widget _tabBarView() {
    return Expanded(
      child:Container(
        color: CustomColors.background1,
        child: _currentIndex == 0 ? LoginInputView() : RegisterInputView(),
      ),
    );
  }
}

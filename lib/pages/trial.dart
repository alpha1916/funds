import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'trial/my_trial_page.dart';
import 'trial/take_trial_page.dart';

class TrialView extends StatefulWidget {
  @override
  _TrialViewState createState() => _TrialViewState();
}

class _TrialViewState extends State<TrialView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('活动专区'),
          leading: Utils.buildServiceIconButton(context),
        ),
        body: Container(
            color: CustomColors.trialBackground,
            child: Column(
              children: <Widget>[
                _createCenterText(
                    '全民来配资，${Global.appName}新体验',
                    TextStyle(fontSize: a.px26, color: Color(0xFFFEFDAC)),
                    EdgeInsets.only(top: a.px40)),
                _createCenterText(
                    '已参与体验',
                    TextStyle(fontSize: a.px16, color: Colors.white),
                    EdgeInsets.only(top: a.px15)),
                _createCenterText(
                    '140598',
                    TextStyle(fontSize: a.px28, color: Color(0xFFFEFA85)),
                    EdgeInsets.only(top: a.px1)
                ),
                _ContentView(),
              ],
            )));
  }

  Widget _createCenterText(
      String text, TextStyle style, EdgeInsetsGeometry padding) {
    return Container(
      padding: padding,
      child: Center(
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }

}

class _ContentView extends StatefulWidget {
  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView>
    with SingleTickerProviderStateMixin{
  TabController _tabController;
  final _titles = ['参加体验', '我的体验'];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: a.px20, right: a.px20, top: a.px10, bottom: a.px40),
        decoration: BoxDecoration(
          color: CustomColors.trialContentBackground,
          borderRadius: BorderRadius.all(Radius.circular(a.px12)),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(a.px12)),
          child: Column(
            children: <Widget>[
              _tabBar(),
              _buildContentView(),
            ],
          ),
        ),
      ),
    );
  }

  _buildContentView(){
    if(_currentIndex == 0)
      return TakeTrialPage();

    return MyTrialPage(() => setState(() => _tabController.index = _currentIndex = 0));
  }

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
    super.dispose();
    _tabController.dispose();
  }

  Widget _tabBar() {
    return TabBar(
      tabs: _titles.map((title) {
        return Text(title);
      }).toList(),
      controller: _tabController,
      indicatorColor: Colors.red,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: false,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      indicatorWeight: a.px3,
      labelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5), fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5)),
    );
  }
}
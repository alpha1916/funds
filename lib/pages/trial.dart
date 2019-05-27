import 'package:flutter/material.dart';
import '../common/constants.dart';
import 'trial/my_trial_page.dart';
import 'trial/take_trial_page.dart';

class TrialView extends StatefulWidget {
  @override
  _TrialViewState createState() => _TrialViewState();
}

class _TrialViewState extends State<TrialView> {

  @override
  Widget build(BuildContext context) {
    final Widget iconService = Image.asset(CustomIcons.service,
        width: CustomSize.icon, height: CustomSize.icon);
    return Scaffold(
        appBar: AppBar(
          title: Text('体验'),
          leading: IconButton(
              icon: iconService,
              onPressed: () {
                print('press service');
              }),
        ),
//      body: _contentView(),
        body: Container(
            color: CustomColors.trialBackground,
            child: Column(
              children: <Widget>[
                _createCenterText(
                    '全民来配资，XX新体验',
                    TextStyle(fontSize: 26, color: Color(0xFFFEFDAC)),
                    EdgeInsets.only(top: 40)),
                _createCenterText(
                    '已参与体验',
                    TextStyle(fontSize: 16, color: Colors.white),
                    EdgeInsets.only(top: 15)),
                _createCenterText(
                    '140598',
                    TextStyle(fontSize: 28, color: Color(0xFFFEFA85)),
                    EdgeInsets.only(top: 1)
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
  __ContentViewState createState() => __ContentViewState();
}

class __ContentViewState extends State<_ContentView>
    with SingleTickerProviderStateMixin{
  TabController _tabController;
  final _titles = ['参加体验', '我的体验'];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
        decoration: BoxDecoration(
          color: CustomColors.trialContentBackground,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          children: <Widget>[
            _tabBar(),
//            Container(height: 10),
            const SizedBox(height: 10),
            _currentIndex == 0 ? TakeTrialPage() : MyTrialPage(),
          ],
        ),
      ),
    );
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
            print(_currentIndex);
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
      indicatorWeight: 3.0,
      labelStyle: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 17, height: 1.5),
    );
  }
}
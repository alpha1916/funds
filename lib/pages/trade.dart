import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'trade/current_contract.dart';
import 'trade/history_contract.dart';

class TradeView extends StatefulWidget {
  final bool secondary;
  TradeView([this.secondary = false]);
  @override
  _TradeViewState createState() => _TradeViewState(secondary);
}

class _TradeViewState extends State<TradeView>
    with SingleTickerProviderStateMixin{

  final bool secondary;
  _TradeViewState(this.secondary);


  TabController _tabController;
  final List<String> _titles = ['当前合约', '历史合约'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: _titles.length,
      vsync: this,
    );

//    _tabController.index = 1;
//    _tabController.addListener(() {
////      if(_currentIndex != _tabController.index){
////        setState(() {
////          _currentIndex = _tabController.index;
////          print(_currentIndex);
////        });
////      }
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:Text('我的交易'),
        leading: secondary ? null : Utils.buildServiceIconButton(context),
        bottom: TabBar(
          tabs: <Widget>[
            Text('当前合约'),
            Text('历史合约'),
          ],
          controller: _tabController,
          indicatorColor: CustomColors.red,
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: false,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          indicatorWeight: 2.0,
          labelStyle: TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 17, height: 1.5),
        ),
      ),
//      body: Container(
//        color: CustomColors.homeBackground,
//      ),
      body:TabBarView(
        controller: _tabController,
        children: <Widget>[
          CurrentContractPage(),
          HistoryContractPage(),
      ],)
    );
  }
}
import 'package:flutter/material.dart';
import 'package:funds/common/custom_app_bar.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'stock_hold_view.dart';
import 'stock_buy_view.dart';
import 'stock_sell_view.dart';
import 'stock_cancel_view.dart';
import 'stock_query_view.dart';

import 'package:funds/routes/trade/bloc/trade_bloc.dart';


class StockTradeMainPage extends StatefulWidget {
  final String contractTitle;
  StockTradeMainPage(contractNumber, this.contractTitle){
    TradeBloc.getInstance().setContractNumber(contractNumber);
  }
  @override
  _StockTradeMainPageState createState() => _StockTradeMainPageState();
}

class _StockTradeMainPageState extends State<StockTradeMainPage>
    with SingleTickerProviderStateMixin {
  Timer refreshTimer;
  int _currentIndex = 0;
  double cash = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('委托交易', style: TextStyle(fontSize: a.px20)),
        leading: FlatButton(
          child: Container(
            child:Row(
              children: <Widget>[
                Icon(Icons.arrow_back_ios, color: Colors.blueAccent, size: a.px18,),
                Text(widget.contractTitle, style: TextStyle(fontSize: a.px16, color: Colors.blueAccent),),
              ],
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildPageBody(),
      resizeToAvoidBottomPadding: false,
    );
  }

  final tabBarTitles = ['持仓', '买入', '卖出', '撤单', '查询',];
  List<Widget> tabBarViews = [];

  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: tabBarTitles.length,
      initialIndex: _currentIndex,
      vsync: this,
    );

    tabBarViews = [
      StockHoldView(),
      StockBuyView(),
      StockSellView(),
      StockCancelView(),
      StockQueryView(TradeBloc.getInstance().contractNumber),
    ];

    _tabController.addListener((){
      if(_currentIndex != _tabController.index){
        setState(() {
          _currentIndex = _tabController.index;
          TradeBloc.getInstance().clearStockInfo();
          if(_tabController.index < 3)
            _refresh();
          else
            removeAutoRefresh();
        });
      }
    });
    _refresh();
  }

  addAutoRefresh() {
    if(refreshTimer != null)
      return;

    refreshTimer = Timer.periodic(Duration(milliseconds: 3000), (_){
      TradeBloc.getInstance().refresh();
    });
  }

  removeAutoRefresh() {
    refreshTimer?.cancel();
    refreshTimer = null;
  }

  _refresh() {
    TradeBloc.getInstance().refresh();
    addAutoRefresh();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    refreshTimer?.cancel();
    _tabController.dispose();
  }

  _buildPageBody() {
    return Container(
      color: CustomColors.background2,
      child: Column(
        children: <Widget>[
          _buildCashView(),
          SizedBox(height: a.px12),
          _buildTabBar(),
          _buildTabBarView(),
        ],
      )
    );
  }

  _buildCashView() {
    final fontSize = a.px16;
    final hp = a.px16;
    final vp = a.px12;

    TradeBloc bloc = TradeBloc.getInstance();
    return StreamBuilder<double>(
      stream: bloc.moneyStream,
      initialData: bloc.money,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot){
        return Container(
          padding: EdgeInsets.only(left: hp, right: hp, top: vp, bottom: vp),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Text('可用现金', style: TextStyle(fontSize: fontSize)),
              Expanded(child: Container(),),
              Text(Utils.getTrisection(snapshot.data), style: TextStyle(fontSize: fontSize, color: CustomColors.red),),
              Text(' 元', style: TextStyle(fontSize: fontSize)),
            ],
          ),
        );
      },
    );
  }

  _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: tabBarTitles.map<Widget>((title) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: a.px5),
            child: Text(title),
          );
        }).toList(),
        indicatorColor: CustomColors.red,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: false,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorWeight: 2.0,
        labelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5), fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5)),
      ),
    );
  }

  _buildTabBarView() {
//    return Expanded(child: TabBarView(
//      controller: _tabController,
//      children: tabBarViews,
//    ));
    return Expanded(
      child: tabBarViews[_currentIndex],
    );
  }
}

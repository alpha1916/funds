import 'package:flutter/material.dart';
import 'package:funds/common/custom_app_bar.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/network/http_request.dart';

import 'package:flutter/cupertino.dart';

import 'stock_hold_view.dart';
import 'stock_buy_view.dart';
import 'stock_sell_view.dart';
import 'stock_cancel_view.dart';
import 'stock_query_view.dart';

double realWidth;
px(number) {
  return adapt(number, realWidth);
}

class StockTradeMainPage extends StatefulWidget {
  final String contractTitle;
  StockTradeMainPage(this.contractTitle);
  @override
  _StockTradeMainPageState createState() => _StockTradeMainPageState(contractTitle);
}

class _StockTradeMainPageState extends State<StockTradeMainPage>
    with SingleTickerProviderStateMixin {
  final String contractTitle;
  double cash = 0;

  _StockTradeMainPageState(this.contractTitle);
  @override
  Widget build(BuildContext context) {
    realWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('委托交易', style: TextStyle(fontSize: adapt(20, realWidth)),),
        leading: FlatButton(
          child: Container(
            child:Row(
              children: <Widget>[
                Icon(Icons.arrow_back_ios, color: Colors.blueAccent, size: adapt(20, realWidth),),
                Text(contractTitle, style: TextStyle(fontSize: adapt(18, realWidth), color: Colors.blueAccent),),
              ],
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildPageBody(),
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
      initialIndex: 1,
      vsync: this,
    );

    tabBarViews = [
      StockHoldView(),
      StockBuyView(),
      StockSellView(),
      StockCancelView(),
      StockQueryView(),
    ];
  }

  _buildPageBody() {
    return Container(
      color: CustomColors.background2,
      child: Column(
        children: <Widget>[
          _buildCashView(),
          SizedBox(height: 12,),
          _buildTabBar(),
          _buildTabBarView(),
        ],
      )
    );
  }

  _buildCashView() {
    final fontSize = px(16);
    final hp = px(16);
    final vp = px(12);
    return Container(
      padding: EdgeInsets.only(left: hp, right: hp, top: vp, bottom: vp),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('可用现金', style: TextStyle(fontSize: fontSize),),
          Expanded(child: Container(),),
          Text(cash.toStringAsFixed(2), style: TextStyle(fontSize: fontSize, color: CustomColors.red),),
          Text(' 元', style: TextStyle(fontSize: fontSize)),
        ],
      ),
    );
  }

  _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: tabBarTitles.map<Widget>((title) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: px(5)),
            child: Text(title),
          );
        }).toList(),
        indicatorColor: CustomColors.red,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: false,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorWeight: 2.0,
        labelStyle: TextStyle(fontSize: px(17), height: px(1.5), fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: px(17), height: px(1.5)),
      ),
    );
  }

  _buildTabBarView() {
    return Expanded(child: TabBarView(
      controller: _tabController,
      children: tabBarViews,
    ));
  }
}

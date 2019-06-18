import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';

class ContractFlowPage extends StatefulWidget {
  @override
  _ContractFlowPageState createState() => _ContractFlowPageState();
}

class _ContractFlowPageState extends State<ContractFlowPage>
    with SingleTickerProviderStateMixin{
  final data = {
    'capital': 100.00,
    'loan': 2000.00,
    'contractMoney': 2100.00,
    'operateMoney': 2100.00,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('合约流水')
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildInfoView(),
            SizedBox(height: a.px12),
            _buildTabBar(),
            _buildListView(),
          ],
        ),
      ),
    );
  }
  _buildInfoView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, top: a.px10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Text('初始合约信息', style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: a.px10),
          Container(height: a.px(0.5), color: CustomColors.splitLineColor1),
          SizedBox(height: a.px10),
          Table(
            children: <TableRow>[
              TableRow(
                children: [
                  _buildInfoItem('杠杆本金', data['capital'].toStringAsFixed(2)),
                  _buildInfoItem('借款金额', data['loan'].toStringAsFixed(2)),
                ],
              ),
              TableRow(
                children: [
                  _buildInfoItem('合约金额', data['contractMoney'].toStringAsFixed(2)),
                  _buildInfoItem('操盘金额', data['operateMoney'].toStringAsFixed(2)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildInfoItem(title, value) {
    return Container(
      margin: EdgeInsets.only(bottom: a.px10),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: a.px14),
          ),
          SizedBox(
            width: a.px8,
          ),
          Text(
            value,
            style: TextStyle(fontSize: a.px14),
          ),
        ],
      ),
    );
  }

  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
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

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        tabs: <Widget>[
          Text('流水明细'),
          Text('管理费明细'),
        ],
        controller: _tabController,
        indicatorColor: CustomColors.red,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: false,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorWeight: a.px2,
        labelStyle: TextStyle(fontSize: a.px16, height: a.px(1.5), fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: a.px16, height: a.px(1.5)),
      )
    );
  }

  _buildListView() {
    final dataList = [1, 2, 1,1,1,];//1,1,1,1,1,1,1,1,1,1,11,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,11,1,1,1,1,1,1,1,1,1];
//  final dataList = [];
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildCashListView(dataList),
          _buildManagementListView(dataList),
        ],
      )
    );
  }

  _buildCashListView(dataList){
    if(dataList == null || dataList.length == 0){
      return _buildNoDataView();
    }

    final data = {
      'title': '终止合约',
      'value': 200.00,
      'date': '2019-06-04 15:31:01',
      'capital': 100.00,
      'loan': 2000.00,
      'contractMoney': 2100.00,
      'operateMoney': 2100.00,
    };
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
//        final data = _dataList[index];
        return _buildCashItemView(data);
      },
      itemCount: dataList.length,
    );
  }

  _buildCashItemView(data) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, top: a.px10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(data['title'], style: TextStyle(fontSize: 14)),
              SizedBox(width: a.px5),
              Text(data['value'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.red)),
              Expanded(child: Container()),
              Text(data['date'], style: TextStyle(fontSize: 12)),
              SizedBox(width: a.px16),
            ],
          ),
          SizedBox(height: a.px10),
          Table(
            children: <TableRow>[
              TableRow(
                children: [
                  _buildInfoItem('杠杆本金', data['capital'].toStringAsFixed(2)),
                  _buildInfoItem('借款金额', data['loan'].toStringAsFixed(2)),
                ],
              ),
              TableRow(
                children: [
                  _buildInfoItem('合约金额', data['contractMoney'].toStringAsFixed(2)),
                  _buildInfoItem('操盘金额', data['operateMoney'].toStringAsFixed(2)),
                ],
              ),
            ],
          ),
          Container(height: a.px(0.5), color: CustomColors.splitLineColor1),
        ],
      ),
    );
  }

  _buildManagementListView(dataList){
    if(dataList == null || dataList.length == 0){
      return _buildNoDataView();
    }
    final data = {
      'title': '终止合约',
      'value': -200.00,
      'date': '2019-06-04 15:31:01',
      'balance': 100.00,
    };
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
//      final data = dataList[index];
      return Container(
        child: _buildManagementItemView(data),
        alignment: Alignment.center,
      );
    },
      itemCount: dataList.length,
    );
  }

  _buildNoDataView() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: a.px20, bottom: a.px40),
          color: Colors.white,
          child: Center(
            child: Text('当前没有数据', style: TextStyle(fontSize: 14, color: Colors.black38)),
          )
        ),
      ],
    );
  }

  _buildManagementItemView(data){
    return Container(
      padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('管理费用', style: TextStyle(fontSize: a.px14, fontWeight: FontWeight.w500)),
              Text(data['value'].toStringAsFixed(2), style: TextStyle(fontSize: a.px14, color: Colors.green)),
            ],
          ),
          SizedBox(height: a.px10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('余额:${data['balance'].toStringAsFixed(2)}', style: TextStyle(fontSize: a.px14)),
              Text(data['date'], style: TextStyle(fontSize: a.px14)),
            ],
          ),
          SizedBox(height: a.px8,),
          Container(height: a.px(0.5), color: CustomColors.splitLineColor1),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';

import 'package:funds/network/contract_request.dart';
import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';

class ContractFlowPage extends StatefulWidget {
  final ContractData data;
  ContractFlowPage(this.data);
  @override
  _ContractFlowPageState createState() => _ContractFlowPageState();
}

class _ContractFlowPageState extends State<ContractFlowPage>
    with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('合约流水')
      ),
      body: Column(
        children: <Widget>[
          _buildInfoView(),
          SizedBox(height: a.px12),
          _buildTabBar(),
          _buildListView(),
        ],
      ),
    );
  }
  _buildInfoView() {
    final ContractData data = widget.data;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, top: a.px10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: FractionalOffset.centerLeft,
            child: Text('初始合约信息', style: TextStyle(fontSize: a.px16)),
          ),
          SizedBox(height: a.px10),
          Divider(height: 0,),
          SizedBox(height: a.px10),
          Table(
            children: <TableRow>[
              TableRow(
                children: [
                  _buildInfoItem('杠杆本金', data.capital.toStringAsFixed(2)),
                  _buildInfoItem('借款金额', data.loan.toStringAsFixed(2)),
                ],
              ),
              TableRow(
                children: [
                  _buildInfoItem('合约金额', data.contractMoney.toStringAsFixed(2)),
                  _buildInfoItem('操盘金额', data.startOperateMoney.toStringAsFixed(2)),
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
            style: TextStyle(fontSize: a.px16),
          ),
          SizedBox(
            width: a.px8,
          ),
          Text(
            value,
            style: TextStyle(fontSize: a.px16),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        tabs: <Widget>[
          Text('流水明细'),
          Text('担保费明细'),
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
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildCashListView(),
          _buildManagementListView(),
        ],
      )
    );
  }

  _buildCashListView(){
    ListPageDataHandler listPageDataHandler = ListPageDataHandler(
      itemConverter: (data) => ContractMoneyFlowData(data),
      requestDataHandler: (pageIndex, pageCount) async{
        var result = await ContractRequest.getFlowCashList(widget.data.contractNumber, pageIndex, pageCount);
        return result.data;
      }
    );


    return CustomRefreshListView(
      indexedWidgetBuilder: _buildCashItemView,
      refreshHandler: listPageDataHandler.refresh,
      loadMoreHandler: listPageDataHandler.loadMore,
      noDataViewBuilder: _buildNoDataView,
    );
  }

  Widget _buildCashItemView(context, index, srcData) {
    ContractMoneyFlowData data = srcData;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, top: a.px10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(data.title, style: TextStyle(fontSize: a.px16)),
              SizedBox(width: a.px5),
              Text(data.value.toString(), style: TextStyle(fontSize: a.px16, color: CustomColors.red)),
              Expanded(child: Container()),
              Text(data.date, style: TextStyle(fontSize: a.px14)),
              SizedBox(width: a.px16),
            ],
          ),
          SizedBox(height: a.px10),
          Table(
            children: <TableRow>[
              TableRow(
                children: [
                  _buildInfoItem('杠杆本金', data.capital.toStringAsFixed(2)),
                  _buildInfoItem('借款金额', data.loan.toStringAsFixed(2)),
                ],
              ),
              TableRow(
                children: [
                  _buildInfoItem('合约金额', data.contractMoney.toStringAsFixed(2)),
                  _buildInfoItem('操盘金额', data.operateMoney.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
          Divider(height: 0,),
        ],
      ),
    );
  }

  _buildManagementListView(){
    ListPageDataHandler listPageDataHandler = ListPageDataHandler(
        itemConverter: (data) => ContractCostFlowData(data),
        requestDataHandler: (pageIndex, pageCount) async{
          var result = await ContractRequest.getFlowManageCostList(widget.data.contractNumber, pageIndex, pageCount);
          return result.data;
        }
    );

    return CustomRefreshListView(
      indexedWidgetBuilder: _buildManagementItemView,
      refreshHandler: listPageDataHandler.refresh,
      loadMoreHandler: listPageDataHandler.loadMore,
      noDataViewBuilder: _buildNoDataView,
    );
  }

  _buildNoDataView() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: a.px20, bottom: a.px40),
          color: Colors.white,
          child: Center(
            child: Text('当前没有数据', style: TextStyle(fontSize: a.px14, color: Colors.black38)),
          )
        ),
      ],
    );
  }

  Widget _buildManagementItemView(context, index, srcData) {
    ContractCostFlowData data = srcData;
    Color valueColor = data.value < 0 ? Colors.green : CustomColors.red;
    return Container(
      padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('担保费用', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500)),
              data.tips == '' ? Container() : Text('（${data.tips}）', style: TextStyle(fontSize: a.px14)),
              Utils.expanded(),
              Text(data.value.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, color: valueColor)),
            ],
          ),
          SizedBox(height: a.px10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('余额:${data.leftMoney.toStringAsFixed(2)}', style: TextStyle(fontSize: a.px16)),
              Text(data.date, style: TextStyle(fontSize: a.px14)),
            ],
          ),
          SizedBox(height: a.px8,),
          Divider(height: 0,),
        ],
      ),
    );
  }
}

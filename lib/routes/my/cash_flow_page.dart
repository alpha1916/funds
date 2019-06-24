import 'package:flutter/material.dart';
import 'package:funds/common/common.dart';
import 'package:funds/network/user_request.dart';

class CashFlowPage extends StatefulWidget {
  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage>
    with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('现金流水'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildTabBar(),
          _buildListView(),
          ],
        ),
      ),
    );
  }

  @override
  initState(){
    super.initState();
    _tabController = TabController(
      length: _titles.length,
      initialIndex: 0,
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
    _getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  _getData() async{
    var result = await UserRequest.getCashFlow();
    if(result.success){
      _totalDataList = result.data;
      setState(() {
      });
    }
  }

  final _titles = ['全部明细', '充值提款', '合约明细'];
  TabController _tabController;
  List<CashFlowData> _totalDataList;
  Map<int, List<CashFlowData>> type2List = {};
  int _currentIndex = 0;

  _buildTabBar(){
    return TabBar(
      tabs: _titles.map((title) => Text(title)).toList(),
      controller: _tabController,
      indicatorColor: CustomColors.red,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: false,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      indicatorWeight: a.px2,
      labelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5), fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5)),
    );
  }

  _getValueText(double value) {
    if(value > 0)
      return '+${value.toStringAsFixed(2)}';
    else
      return value.toStringAsFixed(2);
  }

  _buildListView(){
    final double fontSize = a.px15;
    final List<CashFlowData> showDataList = _getShowDataList();
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index){
          CashFlowData data = showDataList[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: a.px16),
            child: Column(
              children: <Widget>[
                SizedBox(height: a.px10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(cashFlowType2Text[data.type], style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),),
                    Text(_getValueText(data.value), style: TextStyle(fontSize: fontSize, color: Utils.getProfitColor(data.value)),),
                  ],
                ),
                SizedBox(height: a.px10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('现金余额: ${data.remainingSum.toStringAsFixed(2)}', style: TextStyle(fontSize: fontSize, color: Colors.black87)),
                    Text(data.date, style: TextStyle(fontSize: fontSize, color: Colors.black87)),
                  ],
                ),
                SizedBox(height: a.px10),
                Utils.buildSplitLine(),
              ],
            ),
          );
        },
        itemCount: showDataList.length,
      ),
    );
  }

  _getShowDataList() {
    if(_totalDataList == null)
      return <CashFlowData>[];

    var list = type2List[_currentIndex];
    if(list != null)
      return list;

    list = [];
    switch(_currentIndex){
      case 0:
        list = _totalDataList;
        break;

      case 1:
        for(int i = 0; i < _totalDataList.length; ++i){
          CashFlowData data = _totalDataList[i];
          if(data.type == 1 || data.type == 2){
            list.add(data);
          }
        }
        break;

      case 2:
        for(int i = 0; i < _totalDataList.length; ++i){
          CashFlowData data = _totalDataList[i];
          if(data.type >= 3 && data.type <= 7){
            list.add(data);
          }
        }
        break;
    }
    type2List[_currentIndex] = list;
    return list;
  }
}

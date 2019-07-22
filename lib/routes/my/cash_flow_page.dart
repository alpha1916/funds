import 'package:flutter/material.dart';
import 'package:funds/common/common.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';


class CashFlowPage extends StatefulWidget {
  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage>
    with SingleTickerProviderStateMixin{
  final _titles = ['全部明细', '充值提款', '合约明细'];
  TabController _tabController;
  ListPageDataHandler listPageDataHandler;
  CustomRefreshListView _listView;
  int _currentIndex = 0;
  GlobalKey<CustomRefreshListViewState> _listViewKey = GlobalKey<CustomRefreshListViewState>();

  @override
  Widget build(BuildContext context) {
    print('hhh');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('现金流水'),
      ),
      body: Column(
        children: <Widget>[
          _buildTabBar(),
          Expanded(child: _listView),
        ],
      ),
    );
  }

  @override
  initState(){
    super.initState();
    listPageDataHandler = ListPageDataHandler(
      itemConverter: (data) => CashFlowData(data),
      requestDataHandler: (pageIndex, pageCount) async{
        int type = _currentIndex;
        print('type:$type');
        var result = await UserRequest.getCashFlow(type, pageIndex, pageCount);
        return result.data;
      }
    );

    _tabController = TabController(
      length: _titles.length,
      initialIndex: 0,
      vsync: this,
    );

    _tabController.addListener(() {
      if(_currentIndex != _tabController.index){
        _currentIndex = _tabController.index;
        print(_currentIndex);
        listPageDataHandler.init();
        _listViewKey.currentState.refresh();
      }
    });
    
    _listView = CustomRefreshListView(
      key:_listViewKey,
      indexedWidgetBuilder: _itemBuilder,
      refreshHandler: listPageDataHandler.refresh,
      loadMoreHandler: listPageDataHandler.loadMore,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

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

  Widget _itemBuilder(BuildContext context, int index, dynamic srcData){
    CashFlowData data = srcData;
    final double fontSize = a.px15;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px16),
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(cashFlowType2Text[data.type] ?? '未知类型${data.type}', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),),
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
          Divider(height: 0),
        ],
      ),
    );
  }
}

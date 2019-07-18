import 'dart:async';
import 'package:flutter/material.dart';
import 'package:funds/common/common.dart';
import 'package:funds/network/user_request.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum PullState {
  normal,
  pulled,
  loading,
  nothing,
}

class CashFlowPage extends StatefulWidget {
  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage>
    with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('现金流水'),
      ),
      body: Column(
        children: <Widget>[
          _buildTabBar(),
          _buildListView(),
        ],
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
        _currentIndex = _tabController.index;
        _update();
      }
    });
    _tabController.index = _currentIndex;

    _scrollController.addListener(() {
      if(_pullState == PullState.nothing)
        return;

      if( _pullState == PullState.normal &&
          _scrollController.position.pixels > (_scrollController.position.maxScrollExtent + a.px10)){
        _pullStateStreamController.add(PullState.pulled);
      } else if(_pullState == PullState.pulled){
        if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _pullStateStreamController.add(PullState.loading);
          _getMoreData();
        }else if(_scrollController.position.pixels < _scrollController.position.maxScrollExtent){
          _pullStateStreamController.add(PullState.normal);
        }
      }
    });

    _getData(0, 0, 10);
  }

  _getMoreData() async{
    print('_getMoreData');
    await Future.delayed(Duration(milliseconds: 300));
    List<CashFlowData> list = _getMoreDataList();
    _showDataList.addAll(list);
    if(list.length < 10){
      _pullStateStreamController.add(PullState.nothing);
      _pullState = PullState.nothing;
    }
    else{
      _pullStateStreamController.add(PullState.normal);
      _pullState = PullState.normal;
    }
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  _getData(type, pageIndex, pageCount) async{
    var result = await UserRequest.getCashFlow(type, pageIndex, pageCount);
    if(result.success){
      _totalDataList = result.data;
      _update();
    }
  }

  _update(){
    setState(() {
      _showDataList = null;
      _showDataList = _getMoreDataList();
      if(_showDataList.length < 10){
        _pullStateStreamController.add(PullState.nothing);
        _pullState = PullState.nothing;
      }
      else{
        _pullStateStreamController.add(PullState.normal);
        _pullState = PullState.normal;
      }
    });
  }

  final pageCount = 10;
  final _titles = ['全部明细', '充值提款', '合约明细'];
  TabController _tabController;
  List<CashFlowData> _totalDataList;
  Map<int, List<CashFlowData>> type2List = {};
  int _currentIndex = 0;
  List<CashFlowData> _showDataList = [];

  ScrollController _scrollController = ScrollController();
  StreamController<PullState> _pullStateStreamController = StreamController<PullState>.broadcast();
  PullState _pullState = PullState.normal;

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
    if(_showDataList == null || _showDataList.length == 0)
      return Container();
    final double fontSize = a.px15;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index){
          if(index == _showDataList.length)
            return _buildLoadMoreTipsView();

          CashFlowData data = _showDataList[index];
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
                Divider(height: 1),
              ],
            ),
          );
        },
        itemCount: _showDataList.length + 1,
        controller: _scrollController,
      ),
    );
  }

  _buildLoadMoreTipsView(){
    return StreamBuilder(
      stream: _pullStateStreamController.stream,
      initialData: _pullState,
      builder: (BuildContext context, AsyncSnapshot<PullState> snapshot){
        _pullState = snapshot.data;
        Widget view;
        if(_pullState == PullState.normal){
          view = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_upward, size: a.px24,),
              Text('上拉可以加载更多'),
            ],
          );
        }else if(_pullState == PullState.pulled){
          view = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_downward, size: a.px24,),
              Text('松开立即加载更多'),
            ],
          );
        }else if(_pullState == PullState.loading){
          view = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitCircle(color: Colors.black, size: a.px24),
              SizedBox(width: a.px10,),
              Text('加载中。。。'),
            ],
          );
        }else if(_pullState == PullState.nothing){
          view = Text('已无更多数据');
        }

        return Container(
            padding: EdgeInsets.only(top: a.px16),
            child: Center(
              child: view,
            )
        );
      },
    );
  }

  _getMoreDataList() {
    if(_totalDataList == null)
      return <CashFlowData>[];

    var list = type2List[_currentIndex];
    if(list == null){
      list = [];
      switch(_currentIndex){
        case 0:
          list = _totalDataList.toList();
//          list.addAll(list.toList());
//          list.addAll(list.toList());
//          list.addAll(list.toList());
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
            if(data.type >= 3){
              list.add(data);
            }
          }
          break;
      }
      type2List[_currentIndex] = list;
    }

    int startIdx = _showDataList?.length ?? 0;
    int endIdx = startIdx + pageCount;
    if(endIdx > (list.length - 1))
      endIdx = list.length;

    var result = list.sublist(startIdx, endIdx);
//    print('$startIdx, $endIdx,${result.length}');
    return result;
  }
}

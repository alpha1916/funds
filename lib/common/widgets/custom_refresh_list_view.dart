import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:core';

typedef CustomRefreshListIndexedWidgetBuilder = Widget Function(BuildContext context, int index, dynamic data);

class CustomRefreshListView extends StatefulWidget {
  CustomRefreshListView({
    GlobalKey<CustomRefreshListViewState> key,
    @required this.indexedWidgetBuilder,
    @required this.refreshHandler,
    @required this.loadMoreHandler,
    this.noDataViewBuilder,
  }):super(key: key);

  final CustomRefreshListIndexedWidgetBuilder indexedWidgetBuilder;
  final refreshHandler;
  final loadMoreHandler;
  final noDataViewBuilder;
  @override
  CustomRefreshListViewState createState() => CustomRefreshListViewState();
}

class CustomRefreshListViewState<T> extends State<CustomRefreshListView> {
  final GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  final GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  final GlobalKey<RefreshHeaderState> _connectorHeaderKey = GlobalKey<RefreshHeaderState>();
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  final GlobalKey<RefreshFooterState> _connectorFooterKey = GlobalKey<RefreshFooterState>();

  List<T> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    if((dataList == null || dataList.length == 0) && widget.noDataViewBuilder != null){
      return widget.noDataViewBuilder();
    }

    Widget header = ClassicsHeader(
      key: _headerKey,
      refreshText: "下拉刷新",
      refreshReadyText: "释放刷新",
      refreshingText: "正在刷新...",
      refreshedText: "刷新完成",
      moreInfo: "更新于 %T",
      bgColor: Colors.transparent,
      textColor: Colors.black,
      refreshHeight: 50,
    );
    Widget footer = ClassicsFooter(
      key: _footerKey,
      loadHeight: 50.0,
      loadText: "上拉加载",
      loadReadyText: "释放加载",
      loadingText: "正在加载",
      loadedText: "加载结束",
      noMoreText: "已显示所有数据",
      moreInfo: "更新于 %T",
      bgColor: Colors.transparent,
      textColor: Colors.black,
    );
    return EasyRefresh(
        key: _easyRefreshKey,
        behavior: ScrollOverBehavior(),
        refreshHeader: ConnectorHeader(
          key: _connectorHeaderKey,
          header: header,
        ),
        refreshFooter: ConnectorFooter(
          key: _connectorFooterKey,
          footer: footer,
        ),
        child: CustomScrollView(
          semanticChildCount: dataList.length,//str.length,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[header]),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                  _indexedWidgetBuilder,
                  childCount: dataList.length,//str.length,
                )),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[footer]),
            )
          ],
        ),
        onRefresh: refresh,
        loadMore: _loadMore,
    );
  }

  Widget _indexedWidgetBuilder(BuildContext context, int index){
    return widget.indexedWidgetBuilder(context, index, dataList[index]);
  }

  Future<void> refresh() async {
    print('refresh');
    dataList = await widget.refreshHandler();
    setState(() {

    });
  }

  Future<void> _loadMore()async {
    print('load more');
    List<T> list = await widget.loadMoreHandler();
    if(list == null || list.length == 0)
      return;

    setState(() {
      dataList.addAll(list);
    });
  }
}

//class CustomHeader extends ClassicsHeader{
//  final double fontSize;
//  CustomHeader({
//    @required GlobalKey<RefreshHeaderState> key,
//    this.fontSize,
//    refreshHeight,
//  }):super(
//    key: key,
//    refreshText: "下拉刷新",
//    refreshReadyText: "释放刷新",
//    refreshingText: "正在刷新...",
//    refreshedText: "刷新完成",
//    moreInfo: "更新于 %T",
//    bgColor: Colors.transparent,
//    textColor: Colors.black,
//  );
//}
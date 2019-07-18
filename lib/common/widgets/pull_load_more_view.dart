import 'package:flutter/material.dart';

class PullLoadMoreView extends StatefulWidget {
  final getMoreDataCallback;
  final IndexedWidgetBuilder itemBuilder;
  final initDataList;
  PullLoadMoreView({
    this.getMoreDataCallback,
    this.initDataList,
    this.itemBuilder,
  });
  @override
  _PullLoadMoreViewState createState() => _PullLoadMoreViewState();
}

class _PullLoadMoreViewState extends State<PullLoadMoreView> {
  ScrollController _scrollController;
  List<int> list = [1, 2, 3];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() async{
      //判断 当滑动到最底部的时候，去加载更多的数据
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //此时加载下一页数据
        var dataList = await widget.getMoreDataCallback();

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: list.length + 1,
      itemBuilder: widget.itemBuilder,
      controller: _scrollController,
    );
  }

  @override
  dispose(){
    _scrollController.dispose();

    super.dispose();
  }

  _doRefresh(){

  }
}

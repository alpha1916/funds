//import 'package:flutter/material.dart';
//
//class PullLoadMoreView extends StatefulWidget {
//  @override
//  _PullLoadMoreViewState createState() => _PullLoadMoreViewState();
//}
//
//class _PullLoadMoreViewState extends State<PullLoadMoreView> {
//  ScrollController _scrollController = new ScrollController();
//  List<int> list = [1, 2, 3];
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//
//    _scrollController.addListener(() {
//      //判断 当滑动到最底部的时候，去加载更多的数据
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        //此时加载下一页数据
//        _getMoreData();
//      }
//    });
//  }
//  @override
//  Widget build(BuildContext context) {
//    return  ListView.builder(
//      itemCount: list.length + 1,
//      itemBuilder: (BuildContext context, int index) {
//
//      },
//      controller: _scrollController,
//    );
//  }
//
//  _doRefresh(){
//
//  }
//}

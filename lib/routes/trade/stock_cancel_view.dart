import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/stock_trade_request.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'bloc/trade_bloc.dart';

var ctx;
var realWidth;

class StockCancelView extends StatefulWidget {
  @override
  _StockCancelViewState createState() => _StockCancelViewState();
}

class _StockCancelViewState extends State<StockCancelView> {
  List<StockEntrustData> _dataList = [];
  List<int> _selectedIdxs = [];
  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
    ResultData result = await StockTradeRequest.getEntrustList(TradeBloc.getInstance().contractNumber);

    if(result.success && mounted){
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    realWidth = MediaQuery.of(context).size.width;
    ctx = context;
    double leftPadding = a.px10;
    double rightPadding = 0;
    double itemWidth = realWidth - leftPadding - rightPadding;
    List<double> sizeList = _sizeListRate.map((rate) => itemWidth * rate).toList();

    return Column(
      children: <Widget>[
        _buildTitleList(sizeList, leftPadding, rightPadding),
        Container(height: a.px1, color: Colors.black12),
        Expanded(
          child:ListView.builder(
            itemBuilder: (BuildContext context, int index){
              return _buildStockItem(index, sizeList, leftPadding, rightPadding);
            },
            itemCount: _dataList.length,
          ),
        ),
        _buildButton(),
      ],
    );
  }

  final _titles = ['', '名称/代码', '价格/数量', '状态/类型', '委托时间'];
  final List<double> _sizeListRate = [0.1, 0.2, 0.2, 0.2, 0.3];

  _buildTitleList(sizeList, leftPadding, rightPadding) {
    return Container(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: a.px8, bottom: a.px8),
      child:Row(
        children: _titles.map((title){
          final int idx = _titles.indexOf(title);
          if(idx == 4){
            return Container(
                width: sizeList[idx],
                child: Align(
                  alignment: FractionalOffset.center,
                  child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.grey),)
                ),
            );
          }
          return Container(
              width: sizeList[idx],
              child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.grey),)
          );
        }).toList(),
      ),
    );
  }

  _buildStockItem(index, sizeList, leftPadding, rightPadding) {
    StockEntrustData data = _dataList[index];
    double fontSize = a.px15;
    bool selected = _selectedIdxs.contains(index);
    IconData selectedIconData = selected ? Icons.brightness_1 : Icons.panorama_fish_eye;
    Widget itemView = Container(
//      margin: EdgeInsets.only(right: rightPadding, top: a.px8, bottom: a.px8),
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px10),
          Row(
            children: <Widget>[
              //选中标记
              Container(
                padding: EdgeInsets.only(left: leftPadding),
                width: sizeList[0],
                child: Icon(selectedIconData, color: Color(0xFFFE7301), size: a.px30),
              ),

              //名称/代码
              Container(
                padding: EdgeInsets.only(left: leftPadding),
                width: sizeList[1],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.title, style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.code.toString(), style: TextStyle(fontSize: fontSize),),
                    ),
                  ],
                ),
              ),
              //价格/数量'
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[2],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.price.toString(), style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.count.toString(), style: TextStyle(fontSize: fontSize)),
                    ),
                  ],
                ),
              ),
              //状态/类型
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[3],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.strState, style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.type == TradeType.buy ? '买入' : '卖出', style: TextStyle(fontSize: fontSize, color: Utils.getEntrustTypeColor(data.type))),
                    ),
                  ],
                ),
              ),
              //委托时间
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[4],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.strDay, style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.strTime, style: TextStyle(fontSize: fontSize)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: a.px10),
          Container(height: a.px1, color: Colors.black12),
        ],
      ),
    );

    return InkWell(
      child: itemView,
      onTap: () {
        print('select item:$index');
        setState(() {
          if(selected)
            _selectedIdxs.remove(index);
          else
            _selectedIdxs.add(index);

          print(_selectedIdxs);
        });
      },
    );
  }

  _buildButton() {
    return Container(
      width: realWidth,
      height: a.px50,
      child: RaisedButton(
        child: Text(
          '撤单',
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: _onPressedCancel,
        color: Colors.black87,
      ),
    );
  }

  _onPressedCancel() async{
    print('cancel');
    if(_selectedIdxs.length == 0){
      alert2('提示', '请选择需要撤单的委托', '确定');
      return;
    }

    List<int> ids = [];
    for(int i = 0; i < _selectedIdxs.length; ++i){
      StockEntrustData data = _dataList[_selectedIdxs[i]];
      print('撤销id:' + data.id.toString());
      ids.add(data.id);
    }
    ResultData result = await StockTradeRequest.cancel(ids.join(','));
    if(result.success){
      alert('撤销已提交，请稍候刷新查看');
    }
  }
}

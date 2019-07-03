import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/stock_trade_request.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'bloc/trade_bloc.dart';

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

    if(mounted)
      _refresh();
  }

  _refresh() async{
    ResultData result = await StockTradeRequest.getEntrustList(TradeBloc.getInstance().contractNumber);
    print('--------------------------------------cancel refresh');

    if(result.success && mounted){
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _rowFlex = [3, 4, 4, 4, 6];
    return Column(
      children: <Widget>[
        _buildTitleColumn(),
        Divider(height: a.px1,),
        _buildDataRows(),
        _buildButton(),
      ],
    );
  }

  List<int> _rowFlex = [2, 2, 2, 2, 3];
  final _titles = ['', '名称/代码', '价格/数量', '状态/类型', '委托时间'];

  _buildTitleColumn() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, a.px8, a.px16, a.px8),
      child:Row(
        children: _titles.map((title){
          final int idx = _titles.indexOf(title);
          TextAlign align = idx < 4 ? TextAlign.left : TextAlign.right;
          return Expanded(
            flex: _rowFlex[idx],
            child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.grey), textAlign: align)
          );
        }).toList(),
      ),
    );
  }

  _buildDataRows(){
    return Expanded(
      child:ListView.builder(
        itemBuilder: (BuildContext context, int index){
          return _buildStockItem(index);
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _buildRow({flex, text1, text2, alignment = FractionalOffset.centerLeft, color}){
    return Expanded(
      flex : flex,
      child: Column(
        children: <Widget>[
          Align(
            alignment: alignment,
            child: Text(text1, style: TextStyle(fontSize: a.px15),),
          ),
          SizedBox(height: a.px6,),
          Align(
            alignment: alignment,
            child: Text(text2, style: TextStyle(fontSize: a.px15, color: color),),
          ),
        ],
      ),
    );
  }

  _buildStockItem(index) {
    StockEntrustData data = _dataList[index];
    bool selected = _selectedIdxs.contains(index);
    IconData selectedIconData = selected ? Icons.brightness_1 : Icons.panorama_fish_eye;
    Widget itemView = Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px10),
          Row(
            children: <Widget>[
              //选中标记
              Expanded(
                flex: _rowFlex[0],
                child: Icon(selectedIconData, color: Color(0xFFFE7301), size: a.px30),
              ),
//              //名称/代码
              _buildRow(flex: _rowFlex[1], text1: data.title, text2: data.code),
              //价格/数量'
              _buildRow(flex: _rowFlex[2], text1: data.price.toStringAsFixed(2), text2: Utils.getTrisectionInt(data.count.toString())),
              //状态/类型
              _buildRow(flex: _rowFlex[3], text1: data.strState, text2: data.strType, color: Utils.getEntrustTypeColor(data.entrustType)),
              //委托时间
              _buildRow(flex: _rowFlex[4], text1: data.strDay, text2: data.strTime, alignment: FractionalOffset.centerRight),
              SizedBox(width: a.px16),
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
      width: double.infinity,
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

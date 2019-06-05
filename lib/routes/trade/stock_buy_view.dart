import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'stock_list_view.dart';
import 'package:funds/model/stock_trade_data.dart';

class StockBuyView extends StatefulWidget {
  @override
  _StockBuyViewState createState() => _StockBuyViewState();
}

class _StockBuyViewState extends State<StockBuyView> {
  List<StockData> _dataList = [];
  @override
  Widget build(BuildContext context) {
    realWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          StockTradeFrame(TradeType.buy),
          SizedBox(height: 10,),
          Expanded(
            child: StockListView(_dataList),
          ),
        ],
      ),
    );
  }

  _refresh() async{
    _dataList = await HttpRequest.getStockHoldList();

    if(mounted) setState(() {});
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    _refresh();
  }
}

class StockTradeFrame extends StatefulWidget {
  final type;
  StockTradeFrame(this.type);
  @override
  _StockTradeFrameState createState() => _StockTradeFrameState(type);
}

class _StockTradeFrameState extends State<StockTradeFrame> {
  final type;
  TradingStockData data;
  _StockTradeFrameState(this.type);

//  _getStockData() async{
//    data = await HttpRequest.getTradingStockData(666666);
//    setState(() {
//
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    _getStockData();
    data = HttpRequest.getTradingStockData(666666);
    return Container(
      child: Row(
        children: <Widget>[
          _buildInfoView(),
          _buildListView(),
        ],
      ),
    );
  }

  _buildInfoView() {
    return Container(
      color: Colors.white,
      width: realWidth * 0.6,
      height: realWidth * 0.7,
      child: Column(
        children: <Widget>[
          _buildTitleView(),
          _buildPriceView(),
          _buildLimitView(),
          _buildCountView(),
          _buildButton(),
        ],
      ),
    );
  }

  TextEditingController codeInputController = TextEditingController();
  TextEditingController priceInputController = TextEditingController();
  TextEditingController countInputController = TextEditingController();

  _buildTitleView() {
    return Container(
      margin: EdgeInsets.only(top:a.px20, left: a.px15, right: a.px15),
      padding: EdgeInsets.symmetric(horizontal: a.px10),
//      width: a.px(220),
      height: a.px50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: a.px1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: a.px(100),
            child: TextField(
              textAlign: TextAlign.left,
              controller: codeInputController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '股票代码',
                labelStyle: TextStyle(fontSize: a.px30),
              ),
              autofocus: false,
              onChanged: _onCodeInputChange,
            ),
          ),
          Text(data?.title ?? '', style: TextStyle(fontSize: a.px16),)
        ],
      ),
    );
  }

  _onCodeInputChange(text) {

  }

  _buildPriceView() {
    buildButton(icon, onPressed) {
      Widget view = Container(
        padding: EdgeInsets.only(top: a.px5, bottom: a.px1),
        width: a.px50,
        color: Color(0xFFE9E9FA),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, size: a.px20,),
            Text('0.01', style: TextStyle(fontSize: a.px13),),
          ],
        )
      );

      return GestureDetector(
        child: view,
        onTap: onPressed,
      );
    }
    return Container(
      height: a.px50,
      margin: EdgeInsets.only(top:a.px10, left: a.px15, right: a.px15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: a.px1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildButton(Icons.remove_circle_outline, _onPressMinusPrice),
          Container(
            width: 80,
            child: Center(
              child: TextField(
                textAlign: TextAlign.center,
                controller: priceInputController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.black12,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  labelStyle: TextStyle(fontSize: a.px30),
                ),
                autofocus: false,
                onChanged: _onCodeInputChange,
              ),
            ),
          ),
          buildButton(Icons.add_circle_outline, _onPressAddPrice),
        ],
      ),
    );
  }

  _getInputPrice() {
    double value = 0.00;
    if(priceInputController.text.length > 0){
      value = double.parse(priceInputController.text);
    }
    return value;
  }

  _onPressAddPrice() {
    if(data == null)
      return;

    double price = _getInputPrice();
    price += 0.01;
    priceInputController.text = price.toStringAsFixed(2);
  }

  _onPressMinusPrice() {
    if(data == null)
      return;

    double price = _getInputPrice();
    price -= 0.01;
    if(price < 0.0)
      price = 0.0;

    priceInputController.text = price.toStringAsFixed(2);
  }

  _buildLimitView() {
    buildText(title, [color]) {
      return Text(title, style: TextStyle(fontSize: a.px14, color: color),);
    }

    double downLimitPrice = data?.downLimitPrice ?? 0.00;
    double upLimitPrice = data?.downLimitPrice ?? 0.00;
    return Container(
      margin: EdgeInsets.only(top:a.px10, left: a.px15, right: a.px15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              buildText('跌停 '),
              buildText(downLimitPrice.toStringAsFixed(2), Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              buildText('涨停 '),
              buildText(upLimitPrice.toStringAsFixed(2), CustomColors.red),
            ],
          ),
        ],
      ),
    );
  }

  _buildCountView() {
    String hintText;
    String tips;
    if(type == TradeType.buy){
      int count = 1000;
      hintText = '委买数量';
      tips = '可买 $count 股';
    }else{
      int count = 100;
      hintText = '委卖数量';
      tips = '可卖 $count 股';
    }
    return Container(
      margin: EdgeInsets.only(top:a.px10, left: a.px15, right: a.px15),
      padding: EdgeInsets.symmetric(horizontal: a.px10),
//      width: a.px220),
      height: a.px50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: a.px1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: a.px(100),
            child: TextField(
              textAlign: TextAlign.left,
              controller: codeInputController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(fontSize: a.px16),
                labelStyle: TextStyle(fontSize: a.px15),
              ),
              autofocus: false,
              onChanged: _onCodeInputChange,
            ),
          ),
          Text(tips, style: TextStyle(fontSize: a.px15),)
        ],
      ),
    );
  }

  _onBtnTrade() {

  }

  _buildButton() {
    String title;
    Color color;
    if(type == TradeType.buy){
      title = '买入';
      color = CustomColors.red;
    }else{
      title = '卖出';
      color = Colors.green;
    }

    return Container(
      margin: EdgeInsets.only(top:a.px10, left: a.px15, right: a.px15),
      height: a.px50,
      width: a.px(220),
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: _onBtnTrade,
        color: color,
        shape: StadiumBorder(),
      ),
    );
  }

  /*------------------------------------------------操作 end---------------------------------------------------*/

  /*------------------------------------------------列表 start---------------------------------------------------*/
  _buildListView() {
    return Container(
      color: Colors.white,
      width: realWidth * 0.4,
      height: realWidth * 0.7,
      padding: EdgeInsets.symmetric(vertical: a.px16),
      child: Column(
        children: <Widget>[
          _buildSellListView(data.sellList),
          Container(
            margin: EdgeInsets.only(left: a.px4, right: a.px8, bottom: a.px16, top: a.px16),
            color: Colors.black12,
            height: a.px1,
          ),
          _buildBuyListView(data.buyList),
        ],
      ),
    );
  }

  _buildBuyListView(dataList){
    List<Widget> list = [];
    for(int i = 0; i < 5; ++i){
      String strPrice = '--';
      String strCount = '--';
      Color priceColor = Colors.black87;

      var order = dataList[i];
      if(order != null){
        double price = order[0];
        strPrice = order[0].toStringAsFixed(2);
        strCount = order[1].toString();
        priceColor = Utils.getProfitColor(price - data.closingPrice);
      }

      double width = realWidth * 0.4;
      double fontSize = a.px13;
      list.add(Container(
        margin: EdgeInsets.only(left: a.px4, right: a.px14, top: a.px4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: width * 0.2,
              alignment: FractionalOffset.topLeft,
              child: Text('买${i + 1}', style: TextStyle(fontSize: fontSize),),
            ),
            Container(
              width: width * 0.3,
              alignment: FractionalOffset.center,
              child: Text(strPrice, style: TextStyle(fontSize: fontSize, color: priceColor),),
            ),
            Container(
              width: width * 0.3,
              alignment: FractionalOffset.topRight,
              child: Text(strCount, style: TextStyle(fontSize: fontSize),),
            ),

          ],
        ),
      ));
    }
    return Column(
      children: list,
    );
  }

  _buildSellListView(List<dynamic> dataList){
    List<Widget> list = [];
    for(int i = 4; i >= 0; --i){
      String strPrice = '--';
      String strCount = '--';
      Color priceColor = Colors.black87;

      var order = dataList[i];
      if(order != null){
        double price = order[0];
        strPrice = order[0].toStringAsFixed(2);
        strCount = order[1].toString();
        priceColor = Utils.getProfitColor(price - data.closingPrice);
      }

      double width = realWidth * 0.4;
      double fontSize = a.px13;
      list.add(Container(
        margin: EdgeInsets.only(left: a.px4, right: a.px14, top: a.px4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: width * 0.2,
              alignment: FractionalOffset.topLeft,
              child: Text('卖${i + 1}', style: TextStyle(fontSize: fontSize),),
            ),
            Container(
              width: width * 0.3,
              alignment: FractionalOffset.center,
              child: Text(strPrice, style: TextStyle(fontSize: fontSize, color: priceColor),),
            ),
            Container(
              width: width * 0.3,
              alignment: FractionalOffset.topRight,
              child: Text(strCount, style: TextStyle(fontSize: fontSize),),
            ),

          ],
        ),
      ));
    }
    return Column(
      children: list,
    );
  }
}



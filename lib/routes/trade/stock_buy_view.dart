import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'stock_list_view.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/routes/trade/bloc/trade_bloc.dart';
import 'package:funds/network/stock_trade_request.dart';
import 'package:funds/routes/trade/trade_confirm_dialog.dart';
import 'package:funds/common/custom_dialog.dart';

class StockBuyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          StockTradeFrame(),
          SizedBox(height: a.px10),
          Expanded(
            child: StockListView(onSelectStock),
          ),
        ],
      ),
    );
  }

  onSelectStock(StockHoldData data) {
    TradeBloc.getInstance().getStockInfo(data.code);
  }
}

class StockTradeFrame extends StatelessWidget{
  final TradeBloc bloc = TradeBloc.getInstance();
  TradingStockData stockInfo;

  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      countInputController.text = '100';
      if(bloc.stockInfo == null)
        bloc.getStockInfo('002656');
    }

    return StreamBuilder<TradingStockData>(
      stream: bloc.stockStream,
      initialData: bloc.stockInfo,
      builder: (BuildContext context, AsyncSnapshot<TradingStockData> snapshot){
        stockInfo = snapshot.data;
        if(stockInfo != null){
          codeInputController.text = stockInfo.code;
          priceInputController.text = Utils.convertDoubleString(stockInfo.lastPrice);
          updateUsableCount(stockInfo.lastPrice);
        }else{
          updateUsableCount(0.0);
        }

        return Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: _buildInfoView(),
              ),
              Expanded(
                flex: 4,
                child: _buildListView(),
              )
            ],
          ),
        );
      },
    );
  }

  String title;

  _buildInfoView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px15, vertical: a.px15),
      child: Column(
        children: <Widget>[
          _buildTitleView(),
          SizedBox(height: a.px10),
          _buildPriceView(),
          SizedBox(height: a.px10),
          _buildLimitView(),
          SizedBox(height: a.px10),
          buildCountView(),
          _buildButton(),
        ],
      ),
    );
  }

  TextEditingController codeInputController = TextEditingController();
  TextEditingController priceInputController = TextEditingController();
  TextEditingController countInputController = TextEditingController();
  _buildTitleView() {
    FocusNode codeInputFocusNode = FocusNode();
    return Builder(
      builder: (context){
        return InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: a.px10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: a.px1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: codeInputFocusNode,
                    textAlign: TextAlign.left,
                    controller: codeInputController,
                    cursorColor: Colors.black12,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '股票代码',
                      hintStyle: TextStyle(fontSize: a.px16),
                      labelStyle: TextStyle(fontSize: a.px16),
                    ),
                    autofocus: false,
                    onChanged: _onCodeInputChange,
                  ),
                ),
                Text(stockInfo?.title ?? '', style: TextStyle(fontSize: a.px16)),
              ],
            ),
          ),
          onTap: (){
            FocusScope.of(context).requestFocus(codeInputFocusNode);
          },
        );
      },
    );

  }

  _onCodeInputChange(text) {
    if(text.length == 6 && RegExp(r'^\d{6}$').hasMatch(text)){
      bloc.getStockInfo(text);
      return;
    }
    bloc.clearStockInfo();
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

      return InkWell(
        child: view,
        onTap: onPressed,
      );
    }

    FocusNode focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _checkPriceInput();
      }
    });

    return Container(
      height: a.px50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: a.px1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildButton(Icons.remove_circle_outline, _onPressMinusPrice),
          Container(
            width: a.px(80),
            child: Center(
              child: TextField(
                focusNode: focusNode,
                textAlign: TextAlign.center,
                controller: priceInputController,
                cursorColor: Colors.black12,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  labelStyle: TextStyle(fontSize: a.px30),
                ),
                autofocus: false,
                onChanged: onPriceInputChange,
              ),
            ),
          ),
          buildButton(Icons.add_circle_outline, _onPressAddPrice),
        ],
      ),
    );
  }

  onPriceInputChange(text) {
    updateUsableCount(getInputPrice());
  }

  _checkPriceInput() {
    if(stockInfo == null || priceInputController.text.isEmpty)
      return;

    double price = getInputPrice();
    if(price < stockInfo.downLimitedPrice)
      price = stockInfo.downLimitedPrice;
    else if(price > stockInfo.upLimitedPrice)
      price = stockInfo.upLimitedPrice;

    priceInputController.text = price.toStringAsFixed(2);
  }

  updateUsableCount(price){
    bloc.updateUsableCount(price);
  }

  getInputPrice() {
    if(priceInputController.text.length > 0){
      double value = double.parse(priceInputController.text);
      if(value > 0){
        return value;
      }
    }
    return 0.0;
  }

  _onPressAddPrice() {
    if(stockInfo == null)
      return;

    double price = getInputPrice();
    price += 0.01;
    if(price > stockInfo.upLimitedPrice)
      price = stockInfo.upLimitedPrice;
    priceInputController.text = price.toStringAsFixed(2);
    onPriceInputChange('');
  }

  _onPressMinusPrice() {
    if(stockInfo == null)
      return;

    double price = getInputPrice();
    price -= 0.01;
    if(price < stockInfo.downLimitedPrice)
      price = stockInfo.downLimitedPrice;

    priceInputController.text = price.toStringAsFixed(2);
    onPriceInputChange('');
  }

  _buildLimitView() {
    buildText(title, [color]) {
      return Text(title, style: TextStyle(fontSize: a.px14, color: color),);
    }

    double downLimitPrice = stockInfo?.downLimitedPrice ?? 0.00;
    double upLimitPrice = stockInfo?.upLimitedPrice ?? 0.00;
    return Container(
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

  String tradeCountHintText = '委买数量';
  String tradeCountPrefix = '可买';
  String tradeButtonTitle = '买入';
  Color tradeButtonColor = CustomColors.red;

  buildCountView() {
    return buildUsableCountView(bloc.countStream, bloc.usableCount);
  }

  buildUsableCountView(Stream<int> steam, int initCount) {
    FocusNode countInputFocusNode = FocusNode();
    return StreamBuilder<int>(
      stream: steam,
      initialData: initCount,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){
        String tips = tradeCountPrefix + '${snapshot.data}股';
        return InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: a.px10),
            height: a.px50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: a.px1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: countInputFocusNode,
                    textAlign: TextAlign.left,
                    controller: countInputController,
                    cursorColor: Colors.black12,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: tradeCountHintText,
                      hintStyle: TextStyle(fontSize: a.px16),
                      labelStyle: TextStyle(fontSize: a.px15),
                    ),
                    autofocus: false,
                  ),
                ),
                Text(tips, style: TextStyle(fontSize: a.px15),)
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(countInputFocusNode);
          },
        );
      },
    );
  }

  Future<bool> queryTradeConfirm(type, count, price) async{
    var data = {
      'code': stockInfo.code,
      'title': stockInfo.title,
      'price': price,
      'count': count,
    };

    var confirm = await CustomDialog.showCustomDialog(TradeConfirmDialog(type, data));
    return confirm != null;
  }

  bool validPrice(price){
    if(price > stockInfo.upLimitedPrice){
      alert2('提示', '购买价格不能高于今日涨停价', '确定');
      return false;
    }else if(price < stockInfo.downLimitedPrice){
      alert2('提示', '购买价格不能低于今日跌停价', '确定');
      return false;
    }
    return true;
  }

  onBtnTrade() async{
    if(stockInfo == null)
      return;

    if(countInputController.text.isEmpty){
      alert('请输入委买数量');
      return;
    }

    int count = Utils.parseInt(countInputController.text);

    double price = getInputPrice();
    if(!validPrice(price))
      return;

    bool confirm = await queryTradeConfirm(TradeType.buy, count, price);
    if(!confirm)
      return;

    ResultData result = await StockTradeRequest.buy(
        bloc.contractNumber,
        codeInputController.text,
        price,
        count,
    );

    if(result.success){
      alert('委托成功');
    }
  }

  _buildButton() {
    return Container(
      margin: EdgeInsets.only(top:a.px10, left: a.px15, right: a.px15),
      height: a.px50,
      width: a.px(220),
      child: RaisedButton(
        child: Text(
          tradeButtonTitle,
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: onBtnTrade,
        color: tradeButtonColor,
        shape: StadiumBorder(),
      ),
    );
  }

  /*------------------------------------------------操作 end---------------------------------------------------*/

  /*------------------------------------------------列表 start---------------------------------------------------*/
  _buildListView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: a.px16),
      child: Column(
        children: <Widget>[
          _buildSellListView(stockInfo?.sellList),
          Container(
            margin: EdgeInsets.only(bottom: a.px12, top: a.px12),
            color: Colors.black12,
            height: a.px1,
          ),
          _buildBuyListView(stockInfo?.buyList),
        ],
      ),
    );
  }

  _buildBuyListView(dataList){
    List<Widget> list = [];
    for(int i = 0; i < 5; ++i){
      String strPrice = '0.00';
      String strCount = '--';
      Color priceColor = Colors.black87;

      if(dataList != null){
        var order = dataList[i];
        if(order != null){
          double price = order[0];
          strPrice = order[0].toStringAsFixed(2);
          strCount = order[1].toString();
          priceColor = Utils.getProfitColor(price - stockInfo.preClosingPrice);
        }
      }

      double fontSize = a.px14;
      list.add(Container(
        margin: EdgeInsets.only(left: a.px2, right: a.px14, top: a.px3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text('买${i + 1}', style: TextStyle(fontSize: fontSize),),
            ),
            Expanded(
              flex: 3,
              child: Center(child: Text(strPrice, style: TextStyle(fontSize: fontSize, color: priceColor),)),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(strCount, style: TextStyle(fontSize: fontSize),),
              )
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
      String strPrice = '0.00';
      String strCount = '--';
      Color priceColor = Colors.black87;

      if(dataList != null){
        var order = dataList[i];
        if(order != null){
          double price = order[0];
          strPrice = order[0].toStringAsFixed(2);
          strCount = order[1].toString();
          priceColor = Utils.getProfitColor(price - stockInfo.preClosingPrice);
        }
      }

      double fontSize = a.px14;
      list.add(Container(
        margin: EdgeInsets.only(left: a.px2, right: a.px14, top: a.px3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text('卖${i + 1}', style: TextStyle(fontSize: fontSize),),
            ),
            Expanded(
              flex: 3,
              child: Center(child: Text(strPrice, style: TextStyle(fontSize: fontSize, color: priceColor),)),
            ),
            Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(strCount, style: TextStyle(fontSize: fontSize),),
                )
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



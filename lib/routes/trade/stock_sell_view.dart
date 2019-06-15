import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'stock_buy_view.dart';
import 'stock_list_view.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/routes/trade/bloc/trade_bloc.dart';
import 'package:funds/network/stock_trade_request.dart';

class StockSellView extends StockBuyView {
  @override
  Widget build(BuildContext context) {
    realWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          SellFrame(),
          SizedBox(height: a.px10),
          Expanded(
            child: StockListView(onSelectStock),
          ),
        ],
      ),
    );
  }
}

class SellFrame extends StockTradeFrame {
  SellFrame() {
    tradeCountHintText = '委卖数量';
    tradeCountPrefix = '可卖';
    tradeButtonTitle = '卖出';
    tradeButtonColor = Colors.green;
  }

  @override
  onPriceInputChange(text) {
  }

  @override
  buildCountView() {
    return buildUsableCountView(bloc.saleableCountStream, bloc.saleableCount);
  }

  @override
  updateUsableCount(price){
    bloc.updateSaleableCount(stockInfo?.code);
  }

  @override
  onBtnTrade() async{
    if(stockInfo == null)
      return;

    int count = 0;

    try{
      count = int.parse(countInputController.text);
    }catch(e){
      alert('请输入正确的委卖数量');
      return;
    }
    if(bloc.saleableCount < count){
      alert('委卖数量超过可卖数量');
      return;
    }

    ResultData result = await StockTradeRequest.sell(
      bloc.selectedHoldData.id,
      getInputPrice(),
      count,
    );

    if(result.success){
      alert('委托成功');
    }
  }
}
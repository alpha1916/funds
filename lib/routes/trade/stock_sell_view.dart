import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'stock_buy_view.dart';
import 'stock_list_view.dart';
import 'package:funds/network/stock_trade_request.dart';

class StockSellView extends StockBuyView {
  @override
  Widget build(BuildContext context) {
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
  bool validCount(count){
    if(count == null){
      alert2('提示', '请输入正确的委卖数量', '确定');
      return false;
    }

    if(count % 100 != 0){
      alert2('提示', '委卖数量必须是100的倍数', '确定');
      return false;
    }

    if(bloc.saleableCount < count) {
      alert('委卖数量超过可卖数量');
      return false;
    }

    return true;
  }

  @override
  onBtnTrade() async{
    if(stockInfo == null)
      return;

    int count = Utils.parseInt(countInputController.text);
    if(!validCount(count))
      return;

    double price = getInputPrice();
    if(!validPrice(price))
      return;

    bool confirm = await queryTradeConfirm(TradeType.sell, count, price);
    if(!confirm)
      return;

    ResultData result = await StockTradeRequest.sell(
      bloc.contractNumber,
      stockInfo.code,
      price,
      count,
    );

    if(result.success){
      alert('委托成功');
      bloc.refresh();
    }
  }
}
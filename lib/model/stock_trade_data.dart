import 'package:funds/common/utils.dart';

class StockHoldData{
  int id;
  String title;
  String code;
  int hold;
  int usable;
  double cost;
  double price;

  double value;
  double profit;
  String profitRate;

  StockHoldData(data)
  {
    id = data['id'];
    title = data['secShortname'];
    code = data['secCode'];
    hold = data['holdNo'];
    usable = data['availableNo'];
    cost = data['inHoldMoney'];
    price = data['nowPrice'];

    value = price * hold;
    profit = (price - cost) * hold;
    profitRate = (profit / (value - profit) * 100).toStringAsFixed(2) + '%';
  }
}

class StockEntrustData{
  final int id;
  final String title;
  final String code;
  final double price;
  final int count;
  final int type;
  final String strDay;
  final String strTime;

  StockEntrustData(data):
        id = data['id'],
        title = data['secShortname'],
        code = data['secCode'],
        price = data['entrustPrice'],
        count = data['entrustNumber'],
        type = data['entrustType'],
        strDay = data['entrustTime'].split(' ')[0],
        strTime = data['entrustTime'].split(' ')[1];
}

class TradingStockData{
  final String title;
  final String code;
  final double closingPrice;
  final double upLimitPrice;
  final double downLimitPrice;
  List<dynamic> buyList;
  List<dynamic> sellList;
  TradingStockData(data):
        title = data['secShortname'],
        code = data['secCode'],
        closingPrice = data['yprice'],
        upLimitPrice = data['riseStop'],
        downLimitPrice = data['fallStop']{
    buyList = [];
    sellList = [];
//    "bid": 买一价格
//    "ask": 卖一价格,
//    "bv": 买一数量
//    "av": 卖一数量
    for(var i = 0; i < 5; ++i){
      String strIndex = i == 0 ? '' : '${i + 1}';
      String bidKey = 'bid' + strIndex;
      String bvKey = 'bv' + strIndex;
      String ask = 'ask' + strIndex;
      String av = 'av' + strIndex;
      if(data[bidKey] != null){
        double price = Utils.convertDouble(data[bidKey]);
        int count = data[bvKey];
        buyList.add([price, count]);
      }

      if(data[ask] != null){
        double price = Utils.convertDouble(data[ask]);
        int count = data[av];
        sellList.add([price, count]);
      }
    }

  }
}
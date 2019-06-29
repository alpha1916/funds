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
  final double preClosingPrice;
  final double upLimitedPrice;
  final double downLimitedPrice;
  final double lastPrice;
  List<dynamic> buyList;
  List<dynamic> sellList;
  TradingStockData(data):
        title = data['stockName'],
        code = data['stockCode'],
        lastPrice = Utils.convertDouble(data['lastPrice']),
        preClosingPrice = Utils.convertDouble(data['preClosePrice']),
        upLimitedPrice = Utils.convertDouble(data['uplimitedPrice']),
        downLimitedPrice = Utils.convertDouble(data['downlimitedPrice'])
  {
    buyList = [];
    sellList = [];
//    "bidPrice1": 买一价格
//    "askPrice1": 卖一价格,
//    "bidVolume1": 买一数量
//    "askVolume1": 卖一数量
    for(var i = 1; i <= 5; ++i){
      String bidKey = 'bidPrice$i';
      String bvKey = 'bidVolume$i';
      String askKey = 'askPrice$i';
      String avKey = 'askVolume$i';
      if(data[bidKey] != null){
        double price = Utils.convertDouble(data[bidKey]);
        int count = data[bvKey];
        buyList.add([price, count]);
      }

      if(data[askKey] != null){
        double price = Utils.convertDouble(data[askKey]);
        int count = data[avKey];
        sellList.add([price, count]);
      }
    }

  }
}

class LimitStockData{
  final String code;
  final String name;
  LimitStockData(data):
      code = data['secCode'],
      name = data['secShortname']
  ;
}
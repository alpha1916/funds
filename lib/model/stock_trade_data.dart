class StockData{
  final String title;
  final int code;
  final double value;
  final double profit;
  final String profitRate;
  final int hold;
  final int usable;
  final double cost;
  final double price;

  StockData(data):
      title = data['title'],
      code = data['code'],
      value = data['value'],
      profit = data['profit'],
      profitRate = (data['profit']/ (data['value'] - data['profit']) * 100).toStringAsFixed(2) + '%',
      hold = data['hold'],
      usable = data['usable'],
      cost = data['cost'],
      price = data['price'];
}

class StockCancelData{
  final String title;
  final int code;
  final double price;
  final int count;
  final int type;
  final String strDay;
  final String strTime;

  StockCancelData(data):
        title = data['title'],
        code = data['code'],
        price = data['price'],
        count = data['count'],
        type = data['type'],
        strDay = data['strDay'],
        strTime = data['strTime'];
}

class TradingStockData{
  final String title;
  final int code;
  final double closingPrice;
  final double upLimitPrice;
  final double downLimitPrice;
//  final int buyableCount;
  final List<dynamic> buyList;
  final List<dynamic> sellList;
  TradingStockData(data):
        title = data['title'],
        code = data['code'],
        closingPrice = data['closingPrice'],
        upLimitPrice = data['upLimitPrice'],
        downLimitPrice = data['downLimitPrice'],
//        buyableCount = data['buyableCount'],
        buyList = data['buyList'],
        sellList = data['sellList'];
}
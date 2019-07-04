import 'http_request.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/model/contract_data.dart';

class StockTradeRequest {
  static getStockInfo(code) async {
    final String api = '/api/v1/trade/getStockInfo';
    var data = {'secCode': code};
    var result = await HttpRequest.send(api: api, data: data, isPost: false);
    if(result == null){
      return ResultData(false);
    }

    TradingStockData stockInfo = result['data'] == null ? null : TradingStockData(result['data']);

    return ResultData(true, stockInfo);
  }

  static buy(contractNumber, code, price, count) async{
    final String api = '/api/v1/trade/buyEntrust';
    var data = {
      'contractNumber': contractNumber,
      'secCode': code,
      'price': price,
      'count': count,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static sell(contractNumber, code, price, count) async{
    final String api = '/api/v1/trade/saleEntrust';
    var data = {
      'contractNum': contractNumber,
      'secCode': code,
      'count': count,
      'price': price,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static cancel(entrustId) async{
    final String api = '/api/v1/trade/cancel';
    var data = {
      'entrustId': entrustId,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static getEntrustList(contractNumber) async {
    final String api = '/api/v1/trade/getEntrusts';
    var data = {
      'contractNumber': contractNumber,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<StockEntrustData> dataList = oDataList.map((data) => StockEntrustData(data)).toList();

    return ResultData(true, dataList);
  }

  static getHoldList(contractNumber) async {
    final String api = '/api/v1/trade/holds';
    var data = {
      'contractNumber': contractNumber,
    };
    var result = await HttpRequest.sendTokenGet(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<StockHoldData> dataList = oDataList.map((data) => StockHoldData(data)).toList();

    return ResultData(true, dataList);
  }

  static getFlowList(contractNumber) async {
    final String api = '/api/v1/trade/getContractTradeRecord';
    var data = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenGet(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<TradeFlowData> dataList = oDataList.map((data) => TradeFlowData(data)).toList();

    return ResultData(true, dataList);
  }
}

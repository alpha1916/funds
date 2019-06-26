import 'http_request.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/model/stock_trade_data.dart';

export 'http_request.dart';
export 'package:funds/model/contract_data.dart';

class ContractRequest {
  static Future<ResultData> getConfigs() async {
    final String api = '/api/v1/contract/getContractConfig';
    var result = await HttpRequest.send(api: api);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<ContractApplyItemData> dataList = oDataList.map((data) => ContractApplyItemData(data)).toList();

    return ResultData(true, dataList);
  }

  static Future<ResultData> preApplyContract(type, times, loanAmount) async {
    final String api = '/api/v1/contract/preApplyContract';
    var data = {'type': type, 'times': times, 'loanAmount': loanAmount};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);

    if(result == null){
      return ResultData(false);
    }

    ContractApplyDetailData resultData = ContractApplyDetailData(result['data']);

    return ResultData(true, resultData);
  }

  static Future<ResultData> applyContract(int type, int times, int loanAmount) async {
    final String api = '/api/v1/contract/applyContract';
    var data = {
      'type': type,
      'times': times,
      'loanAmount': loanAmount,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);

    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result);
  }

  //type 0为当前合约，1为历史合约
  static Future<ResultData> getContractList(type) async {
    final String api = '/api/v1/contract/getContract';
    var data = {'isHistory': type};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<ContractData> dataList = oDataList.map((data) => ContractData(data)).toList();

    return ResultData(true, dataList);
  }

  static Future<ResultData> getContractDetail(contractNumber) async {
    final String api = '/api/v1/contract/getContractByNo';
    var data = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);

    if(result == null){
      return ResultData(false);
    }

    ContractData resultData = ContractData(result['data']);

    return ResultData(true, resultData);
  }

  static Future<ResultData> getTradeFlowList(contractNumber) async {
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

  static Future<ResultData> addCapital(contractNumber, capital) async {
    final String api = '/api/v1/contract/addPrincipal';
    var data = {'contractNumber': contractNumber, 'principal': capital};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    return ResultData(result != null);
  }

  static Future<ResultData> applySettlement(contractNumber) async {
    final String api = '/api/v1/contract/settlementContract';
    var data = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    return ResultData(result != null);
  }

  static Future<ResultData> applyDelay(contractNumber, days) async {
    final String api = '/api/v1/contract/delay';
    var data = {'contractNumber': contractNumber, 'days': days};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    return ResultData(result != null);
  }

  static Future<ResultData> getLimitStockList() async {
    final String api = '/api/v1/trade/getForbidStock';
    var result = await HttpRequest.send(api: api, isPost: false);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
//    oDataList = [
//      {'secCode' : '666666', 'secShortname': 'st生物'},
//    ];
    final List<LimitStockData> dataList = oDataList.map((data) => LimitStockData(data)).toList();

    return ResultData(true, dataList);
  }

  static Future<ResultData> withdraw(String contractNumber, double money) async {
    final String api = '/api/v1/contract/cashContract';
    var data = {'contractNumber': contractNumber, 'money': money};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    return ResultData(result != null);
  }
}
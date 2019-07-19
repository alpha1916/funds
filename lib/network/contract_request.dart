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
    var queryParameters = {'type': type, 'times': times, 'loanAmount': loanAmount};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);

    if(result == null){
      return ResultData(false);
    }

    ContractApplyDetailData resultData = ContractApplyDetailData(result['data']);

    return ResultData(true, resultData);
  }

  static Future<ResultData> applyContract(int type, int times, int loanAmount, int couponId) async {
    final String api = '/api/v1/contract/applyContract';
    var queryParameters = {
      'type': type,
      'times': times,
      'loanAmount': loanAmount,
      'ticketId': couponId ?? 0,
    };
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);

    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result);
  }

  //type 0为当前合约，1为历史合约
  static Future<ResultData> getContractList(type, pageIndex, pageCount) async {
    final String api = '/api/v1/contract/getContract';
    var queryParameters = {'isHistory': type};
    var result = await HttpRequest.sendTokenPost(
        api: api,
        queryParameters: queryParameters,
        data: HttpRequest.buildPageData(pageIndex, pageCount)
    );

    if(result == null){
      return ResultData(false);
    }

//    List<dynamic> oDataList = result['data']['result'];
//    final List<ContractData> dataList = oDataList.map((data) => ContractData(data)).toList();

    return ResultData(true, result['data']);
  }

  static Future<ResultData> getContractDetail(contractNumber) async {
    final String api = '/api/v1/contract/getContractByNo';
    var queryParameters = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);

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
    var queryParameters = {
      'contractNumber': contractNumber,
      'principal': capital
    };
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    return ResultData(result != null);
  }

  static Future<ResultData> applySettlement(contractNumber) async {
    final String api = '/api/v1/contract/settlementContract';
    var queryParameters = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    return ResultData(result != null);
  }

  static Future<ResultData> getDelayData(String contractNumber) async {
    final String api = '/api/v1/contract/getContractDelayInfo';
    var queryParameters = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<ContractDelayData> dataList = oDataList.map((data) => ContractDelayData(data)).toList();

    return ResultData(true, dataList);
  }

  static Future<ResultData> applySuspendedCycle(String contractNumber) async {
    final String api = '/api/v1/contract/contractStop';
    var queryParameters = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    return ResultData(result != null);

  }

  static Future<ResultData> applyDelay(contractNumber, days) async {
    final String api = '/api/v1/contract/contractDelay';
    var queryParameters = {
      'contractNumber': contractNumber,
      'day': days
    };
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    return ResultData(result != null);
  }

  static Future<ResultData> getLimitStockList() async {
    final String api = '/api/v1/trade/getForbidStock';
    var result = await HttpRequest.send(api: api, isPost: false);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<LimitStockData> dataList = oDataList.map((data) => LimitStockData(data)).toList();

    return ResultData(true, dataList);
  }

  static Future<ResultData> withdraw(String contractNumber, double money) async {
    final String api = '/api/v1/contract/cashContract';
    var queryParameters = {'contractNumber': contractNumber, 'money': money};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    return ResultData(result != null);
  }

  static Future<ResultData> getFlow(String contractNumber) async {
    final String api = '/api/v1/contract/getContractRecord';
    var data = {'contractNumber': contractNumber};
    var result = await HttpRequest.sendTokenGet(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, ContractFlowData(result['data']));
  }


  //type 1为历史，0位当日
  static Future<ResultData> getDealList(contractNumber, type, [pageIndex = 0, pageCount = 100]) async {
    final String api = '/api/v1/contract/getContractDealRecord';
    final queryParameters = {
      'contractNumber': contractNumber,
      'isHistory': type,
    };

    final data = HttpRequest.buildPageData(0, 100);
    var result = await HttpRequest.sendTokenPost(api: api, data: data, queryParameters: queryParameters);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data']['result'];
    final List<TradeFlowData> dataList = oDataList.map((data) => TradeFlowData.fromDealData(data)).toList();

    return ResultData(true, dataList);
  }

  //type 1为历史，0位当日
  static Future<ResultData> getEntrustList(contractNumber, type) async {
    final String api = '/api/v1/contract/getContractEntrustRecord';
    final queryParameters = {
      'contractNumber': contractNumber,
      'isHistory': type,
    };
    final data = HttpRequest.buildPageData(0, 100);
    var result = await HttpRequest.sendTokenPost(api: api, data: data, queryParameters: queryParameters);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data']['result'];
    final List<TradeFlowData> dataList = oDataList.map((data) => TradeFlowData.fromEntrustData(data)).toList();

    return ResultData(true, dataList);
  }
}
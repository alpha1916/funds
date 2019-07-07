import 'http_request.dart';
export 'http_request.dart';
import 'package:funds/model/coupon_data.dart';

class UserRequest {
  static getUserInfo() async {
    final String api = '/api/v1/user/getUserInfo';
    var result = await HttpRequest.sendTokenPost(api: api, askLogin: false);
    if(result == null){
      return ResultData(false);
    }

    AccountData.getInstance().update(result['data']);
    return ResultData(true);
  }

  static verifyOldPhone(String phone, String captcha) async{
    final String api = '/api/v1/user/checkOldPhone';
    var data = {
      'phone': phone,
      'captcha': captcha,
    };
    var result = await HttpRequest.sendTokenGet(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static modifyBindPhone(String phone, String captcha) async{
    final String api = '/api/v1/user/upBindPhone';
    var data = {
      'phone': phone,
      'captcha': captcha,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static certificate(name, id) async{
    final String api = '/api/v1/user/authentication';
    var data = {
      'name': name,
      'cardNo': id,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static bindBankCard(String bank, String province, String city, String location, String card, String phone) async{
    final String api = '/api/v1/bank/addBank';
    var data = {
      'bankName': bank,
      'bankNo': card,
      'city': city,
      'name': AccountData.getInstance().name,
      'openAddress': location,
      'phone': phone,
      'province': province
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static getBankList() async {
    final String api = '/api/v1/bank/profiles/bankNames';
    var result = await HttpRequest.send(api: api, isPost: false);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    List<BankCardData> dataList = oDataList.map((data) => BankCardData(data)).toList();

    return ResultData(true, dataList);
  }

  static getProvinceList() async {
    final String api = '/api/v1/bank/profiles/provinces';
    var result = await HttpRequest.send(api: api, isPost: false);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result['data']);
  }

  static getCityList(pid) async {
    final String api = '/api/v1/bank/profiles/cities';
    var result = await HttpRequest.send(api: api, isPost: false, data: {'pid': pid});
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result['data']);
  }

  static getCashFlow() async {
    final String api = '/api/v1/capital/getCapitalRecord';
    var result = await HttpRequest.sendTokenPost(api: api);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    List<CashFlowData> dataList = oDataList.map((data) => CashFlowData(data)).toList();

    return ResultData(true, dataList);
  }

  static getIntegralFlow() async {
    final String api = '/api/v1/capital/getScoreRecord';
    var result = await HttpRequest.sendTokenPost(api: api);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    List<IntegralFlowData> dataList = oDataList.map((data) => IntegralFlowData(data)).toList();

    return ResultData(true, dataList);

//    return HttpRequest.requestListData(type:api: api, dataConverter: (data) => IntegralFlowData(data));
  }

  static getMailData(type) async {
    final String api = '/api/v1/mail/getMailList';
    var result = await HttpRequest.sendTokenGet(api: api);
    if(result == null){
      return ResultData(false);
    }

//    List<dynamic> oDataList = result['data'];
//    List<MailData> dataList = oDataList.map((data) => MailData(data)).toList();
    var dataList = MailData.getTestData(type);

    return ResultData(true, dataList);
  }

  static getMyCouponsData() async {
    final String api = '/api/v1/ticket/getMyTicket';
    var result = await HttpRequest.sendTokenGet(api: api);
    if(result == null){
      return ResultData(false);
    }
//    List<dynamic> oDataList = [
////      {'ticketValue': 50, 'expireDate': '2019-06-17'},
////      {'ticketValue': 200,  'expireDate': '2019-06-17'},
////      {'ticketValue': 8000, 'expireDate': '2019-06-17'},
//    ];
    List<dynamic> oDataList = result['data'];
    List<CouponData> dataList = oDataList.map((data) => CouponData.fromSelfData(data)).toList();

    return ResultData(true, dataList);
  }

  static getShopCouponsData() async {
    final String api = '/api/v1/ticket/getTicketList';
    var result = await HttpRequest.sendTokenGet(api: api);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    List<CouponData> dataList = oDataList.map((data) => CouponData.fromShopData(data)).toList();

    return ResultData(true, dataList);
  }

  static exchangeCoupon(couponId) async {
    final String api = '/api/v1/ticket/scoreChangeTicket';
    final data = {
      'ticketId': couponId,
    };
    var result = await HttpRequest.sendTokenGet(api: api, data: data);
    return ResultData(result != null);
  }

  static getBankCardData() async {
    final String api = '/api/v1/bank/getBank';
    var result = await HttpRequest.sendTokenGet(api: api);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, BankCardData(result['data']));
  }

  static getSignData() async {
    final String api = '/api/v1/sign/getSignData';
    var result = await HttpRequest.sendTokenGet(api: api);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, SignData(result['data']));
  }

  static sign() async {
    final String api = '/api/v1/sign/sign';
    var result = await HttpRequest.sendTokenGet(api: api, askLogin: true);
    return ResultData(result != null);
  }

  static getTaskData() async {
    final String api = '/api/v1/task/getTaskList';
    var result = await HttpRequest.sendTokenGet(api: api);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    List<TaskData> dataList = oDataList.map((data) => TaskData(data)).toList();

    return ResultData(true, dataList);
  }

  static agreeRisk() async {
    return Future.value(ResultData(true));
    final String api = '/api/v1/sign/getSignData';
    var result = await HttpRequest.sendTokenGet(api: api);
    return ResultData(result != null);
  }

}
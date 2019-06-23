import 'http_request.dart';

export 'http_request.dart';

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

  static bindBankCard(bank, province, city, location, card, phone) async{
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
    var result = await HttpRequest.send(api: api);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result['data']);
  }

  static getProvinceList() async {
    final String api = '/api/v1/bank/profiles/provinces';
    var result = await HttpRequest.send(api: api);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result['data']);
  }

  static getCityList(pid) async {
    final String api = '/api/v1/bank/profiles/provinces';
    var result = await HttpRequest.send(api: api, data: {'pid': pid});
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result['data']);
  }
}
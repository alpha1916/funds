import 'http_request.dart';
import 'package:funds/model/account_data.dart';

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

  static bindBankCard(bank, province, city, card, phone) async{
    final String api = '/api/v1/user/authentication';
    var data = {
      'bank': bank,
      'province': province,
      'city': city,
      'cardNo': card,
      'phone': phone,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }
}
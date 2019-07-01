import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:connectivity/connectivity.dart';

import 'package:funds/model/contract_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

export 'package:funds/model/account_data.dart';

class CaptchaType {
  static int forgotPassword = 1;
  static int register = 2;
  static int forgotWithdrawPassword = 3;
  static int oldPhone = 4;
  static int newPhone = 5;
}

class HttpRequest {
  static Future<bool> isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

//  static List<int> businessErrorCodes = [500, 501, 502, 503, 512, 400];
  static List<int> noBusinessErrorCodes = [200, 401];

  static void handleUnauthorized(askLogin) {
    print('token Unauthorized');
    AccountData.getInstance().clear();
    if(askLogin)
      Utils.navigateToLoginPage();
  }

  static send({
    @required api,
    data,
    token,
    isPost = true,
    askLogin = true
  }) async{
    bool connected = await isNetworkAvailable();
    if(!connected){
      alert('请检测您的网络是否可用');
      return null;
    }

    try {
      Loading.show();
      print('[${DateTime.now().toString().substring(11)}]http ${isPost? 'post' : 'get'}:$api,data:${data.toString()}');
      Response response;
      RequestOptions options;
      if(token != null) {
        options = RequestOptions(
            headers: {
              "Accept": "*/*",
              'token': token,
            }
        );
        print('token:$token');
      }
      if(isPost){
//        if(token != null) {
//          response = await dio.post(api, queryParameters: data, options: options);
//        }else{
//          response = await dio.post(api, data: data);
//        }
        response = await dio.post(api, data: data, queryParameters: data, options: options);
      }else{
        response = await dio.get(api, queryParameters: data, options: options);
      }

      Loading.hide();
      print('response.statusCode:${response.statusCode}');
      if(response.statusCode == 200){
        var data = response.data;
        print('[${DateTime.now().toString().substring(11)}]response:${data.toString()}');
        if(!noBusinessErrorCodes.contains(data['code'])){
          handleBusinessCode(data['code'], data['desc']);
//          alert(data['desc']);
          return null;
        }

        return data;
      }else if(response.statusCode == 401){
        handleUnauthorized(askLogin);
        return null;
      }else{
        alert('请求数据错误，请联系客服');
        return null;
      }
    } catch (e) {
      Loading.hide();
      if(e.response != null && e.response.statusCode == 401){
        handleUnauthorized(askLogin);
        return null;
      }
      print(e);
//      alert(e.toString());
      alert('请求数据错误，请联系客服');
    }
  }

  static handleBusinessCode(code, desc){
    switch(code){
      //资金不足
      case 504:
        Utils.showMoneyEnoughTips();
        break;

      default:
        if(desc == 'FAIL')
          desc = '请求数据错误，请联系客服';
        alert(desc);
        break;
    }
  }

  static sendTokenPost({
    @required api,
    data,
    askLogin = true
  }) async {
    String token = AccountData.getInstance().token;

    if(askLogin && token == null){
      token = await Utils.navigateToLoginPage();
    }

    return send(api: api, data: data, askLogin: askLogin, token: token);
  }

  static sendTokenGet({
    @required api,
    data,
    askLogin = true
  }) async {
    String token = AccountData.getInstance().token;

    if(askLogin && token == null){
      token = await Utils.navigateToLoginPage();
    }

    return send(api: api, data: data, askLogin: askLogin, token: token, isPost: false);
  }

  static getPhoneCaptcha(int type, String phone) async {
    String api = '/api/v1/getPhoneCaptcha';
    var data = {
      'type': type,
      'phone': phone,
    };
    var result = await HttpRequest.send(api: api, data: data, isPost: false);
    if(result == null)
      return ResultData(false);

    return ResultData(true, result['data']['captcha']);
  }

  static buildBusinessData(success, [data]){
    return {
      success: success,
      data: data,
    };
  }

  static Dio dio;
  static void init(BuildContext context){
    dio = Dio(); // 使用默认配置
    dio.options.baseUrl = 'http://119.29.142.63:8070';
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;

    Loading.init(context);
  }
}

class Loading {
  static bool displaying = false;
  static BuildContext context;
  static init(BuildContext ctx){
    context = ctx;
  }

  static Widget _buildLoadingView() {
    return SpinKitCircle(color: Colors.white, size: a.px(80));
  }

  static show() async {
    if(displaying)
      return;

    displaying = true;
    showDialog(
        context: context,
        builder: (context) => _buildLoadingView(),
        barrierDismissible: false
    );
//    await Future.delayed(Duration(seconds: 3));
//    Utils.navigatePop();
  }

  static hide() {
    if(displaying)
      Utils.navigatePop();
    displaying = false;
  }
}

class ResultData{
  final bool success;
  final dynamic data;
  ResultData(this.success, [this.data]);
}

class LoginRequest {
  static register(String phone, String pwd, String captcha) async {
    final String api = '/api/v1/register';
    var data = {
      "phone": phone,
      "captcha": captcha,
      "password": pwd,
    };
    var result = await HttpRequest.send(api: api, data: data);
    if(result == null)
      return ResultData(false);

    return ResultData(true);
  }

  static login(String phone, String pwd) async {
    final String api = '/api/v1/login';
    var data = {
      "phone": phone,
      "password": pwd,
    };
    var result = await HttpRequest.send(api: api, data: data);
    if(result == null)
      return ResultData(false);

    String token = result['data']['token'];
    //记录到本地
    await AccountData.getInstance().updateToken(token);
    return ResultData(true);
  }

  static setNewPassword(String phone, String pwd, String captcha) async {
    final String api = '/api/v1/forgot-password';
    var data = {
      "phone": phone,
      "captcha": captcha,
      "password": pwd,
    };
    var result = await HttpRequest.send(api: api, data: data);
    if(result == null)
      return ResultData(false);

    return ResultData(true);
  }

  static modifyPassword(String oldPwd, String newPwd) async {
    final String api = '/api/v1/user/upLoginPassword';
    var data = {
      "oldPw":oldPwd,
      "newPw": newPwd,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null)
      return ResultData(false);

    return ResultData(true);
  }
}

class ExperienceRequest {
  static Future<ResultData> getInfoList() async {

    final String api = '/api/v1/experience/getExperienceList';
    var result = await HttpRequest.send(api: api, askLogin: false);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    List<ExperienceInfoData> dataList = oDataList.map((data) => ExperienceInfoData(data)).toList();

    return ResultData(true, dataList);
  }

  static Future<ResultData> preApplyContract(id) async {
    final String api = '/api/v1/experience/preApplyContract';
    var data = {'id': id};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);

    if(result == null){
      return ResultData(false);
    }

    ContractApplyDetailData resultData = ContractApplyDetailData(result['data']);

    return ResultData(true, resultData);
  }

  static Future<ResultData> applyContract(id) async {
    final String api = '/api/v1/experience/applyContract';
    var data = {'id': id};
    var result = await HttpRequest.sendTokenPost(api: api, data: data);

    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result);
  }

  static Future<ResultData> getContractList() async {
    final String api = '/api/v1/experience/getMyExperienceContract';
    var result = await HttpRequest.sendTokenPost(api: api, askLogin: false);
    if(result == null){
      return ResultData(false);
    }

    List<dynamic> oDataList = result['data'];
    final List<ContractData> dataList = oDataList.map((data) => ContractData(data)).toList();
    return ResultData(true, dataList);
  }
}

class RechargeRequest{
  static recharge(double money, String comment) async {
    final String api = '/api/v1/capital/pay/payReq';
    var data = {
      'money': money,
      'remarks': comment,
      'url': 'test',
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static withdraw(double money, String password) async{
    final String api = '/api/v1/capital/cash';
    var data = {
      'money': money,
      'password': password,
    };
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }
}
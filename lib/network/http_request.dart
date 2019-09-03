import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

import 'package:funds/model/contract_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:funds/routes/reward_dialog.dart';

export 'package:funds/model/account_data.dart';
export 'package:dio/dio.dart';

class CaptchaType {
  static int forgotPassword = 1;
  static int register = 2;
  static int forgotWithdrawPassword = 3;
  static int oldPhone = 4;
  static int newPhone = 5;
}

enum RequestType{
  get,
  tokenGet,
  tokenPost,
}

//class ListPageData{
//
//}

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
    queryParameters,
    token,
    isPost = true,
    askLogin = true,
    showLoading = true,
  }) async{
    bool connected = await isNetworkAvailable();
    if(!connected){
      alert('请检测您的网络是否可用');
      return null;
    }

    try {
      if(showLoading)
        Loading.show();
      print('[${DateTime.now().toString().substring(11)}]http ${isPost? 'post' : 'get'}:$api,data:${data.toString()}, queryParameters:${queryParameters.toString()}');
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
        response = await dio.post(api, data: data, queryParameters: queryParameters, options: options);
      }else{
        response = await dio.get(api, queryParameters: data, options: options);
      }

      if(showLoading)
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

        await handleRewardData(data);

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

  static handleRewardData(data) async{
    int rewardType = data['rewardType'] ?? 0;
    int rewardValue = data['rewardValue'] ?? 0;
    if(rewardType > 0 && rewardValue > 0){
      String tips = '+$rewardValue${rewardType2Name[rewardType]}';
      await RewardDialog.show(tips);
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
    queryParameters,
    askLogin = true,
    showLoading = true,
  }) async {
    String token = AccountData.getInstance().token;

    if(askLogin && token == null){
      Utils.navigateToLoginPage();
      return null;
    }
    return send(
        showLoading: showLoading,
        api: api,
        data: data,
        askLogin: askLogin,
        token: token,
        queryParameters: queryParameters,
    );
  }

  static sendTokenGet({
    @required api,
    data,
    queryParameters,
    askLogin = true,
    showLoading = true,
  }) async {
    String token = AccountData.getInstance().token;

    //如未登录，去往登录页面，登录成功，去到首页流程；取消不做任何操作
    if(askLogin && token == null){
      Utils.navigateToLoginPage();
      return null;
    }

    return send(
      api: api,
      data: data,
      queryParameters: queryParameters,
      askLogin: askLogin,
      token: token,
      isPost: false,
      showLoading: showLoading,
    );
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

  static uploadImage(String path) async{
    Loading.show();
    final String api = '/api/v1/user/upLoadImage';
    try{
      File file = File(path);
      List<int> bytes = await file.readAsBytes();
      List<int> result = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 960,
        minWidth: 540,
        quality: 80,
      );

      debugPrint('o len:${bytes.length}');
      debugPrint('c len:${result.length}');

      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
      FormData data = FormData.from({
        'head': UploadFileInfo.fromBytes(
          result,
          name,
          contentType: ContentType.parse("image/$suffix")
        )
      });

      RequestOptions options = RequestOptions(
        headers: {
          "Accept": "*/*",
          'token': AccountData.getInstance().token,
        }
      );
      Response response = await dio.post(api, options: options, data: data);
      Loading.hide();
      if(response.statusCode == 200){
        var data = response.data;
        print('[${DateTime.now().toString().substring(11)}]response:${data.toString()}');
        if(!noBusinessErrorCodes.contains(data['code'])){
          handleBusinessCode(data['code'], data['desc']);
          return null;
        }

        return data['data'];
      }else if(response.statusCode == 401){
        handleUnauthorized(true);
        return null;
      }else{
        print('');
        alert('上传图片错误');
        return null;
      }
    }catch(e){
      Loading.hide();
      alert('上传图片错误');
      return null;
    }
  }

//  static requestListData({
//    @required type,
//    @required api,
//    data,
//    dataConverter,
//    askLogin = true,
//  }) async {
//    var result;
//    switch(type){
//      case RequestType.get:
//        result = await HttpRequest.send(api: api, data: data);
//        break;
//
//      case RequestType.tokenGet:
//        result = await HttpRequest.sendTokenPost(api: api, data: data);
//        break;
//
//      case RequestType.tokenPost:
//        result = await HttpRequest.sendTokenPost(api: api, data: data);
//        break;
//
//    }
//    if(result == null){
//      return ResultData(false);
//    }
//
//    List<dynamic> oDataList = result['data'];
//    List<dynamic> dataList = oDataList.map(dataConverter).toList();
//
//    return ResultData(true, dataList);
//  }

  static buildPageData(pageIndex, pageCount){
    return {
      'currentPage': pageIndex,
      'pageSize': pageCount,
    };

  }

  static Dio dio;
  static void init(BuildContext context){
    dio = Dio(); // 使用默认配置
    dio.options.baseUrl = 'http://119.29.142.63:8070';
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;

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
    var queryParameters = {
      "oldPw":oldPwd,
      "newPw": newPwd,
    };
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
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
    var queryParameters = {'id': id};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);

    if(result == null){
      return ResultData(false);
    }

    ContractApplyDetailData resultData = ContractApplyDetailData(result['data']);

    return ResultData(true, resultData);
  }

  static Future<ResultData> applyContract(id) async {
    final String api = '/api/v1/experience/applyContract';
    var queryParameters = {'id': id};
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);

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
  static recharge(double money, String comment, String imagePath) async {
    String url = await HttpRequest.uploadImage(imagePath);
    if(url == null)
      return ResultData(false);

    final String api = '/api/v1/capital/pay/payReq';
    var queryParameters = {
      'money': money,
      'remarks': comment,
      'url': url,
    };
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static withdraw(double money, String password) async{
    final String api = '/api/v1/capital/cash';
    var queryParameters = {
      'money': money,
      'password': password,
    };
    var result = await HttpRequest.sendTokenPost(api: api, queryParameters: queryParameters);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true);
  }

  static getDetailList(pageIndex, pageCount) async {
    final String api = '/api/v1/capital/getRechargeOrder';
    var data = HttpRequest.buildPageData(pageIndex, pageCount);
    var result = await HttpRequest.sendTokenPost(api: api, data: data);
    if(result == null){
      return ResultData(false);
    }

    return ResultData(true, result['data']);
  }
}
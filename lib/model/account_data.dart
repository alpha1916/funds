import 'package:shared_preferences/shared_preferences.dart';
import 'package:funds/common/utils.dart';
import 'dart:async';

class AccountData {
  static AccountData ins;
  static AccountData getInstance() {
    if(ins == null){
      ins = AccountData();
    }
    return ins;
  }

  String stock = '0.00';
  String cash = '0.00';
  String total = '0.00';
  String phone = '';
  String token;
  List<int> experiences = [];
  
  Stream<AccountData> get dataStream => _streamController.stream;
  StreamController<AccountData> _streamController = StreamController<AccountData>.broadcast();

  bool isLogin() {
    return token != null;
  }

  update(data){
    stock = Utils.convertDoubleString(data['bondWealth']);
    cash = Utils.convertDoubleString(data['cashWealth']);
    total = Utils.convertDoubleString(data['cashWealth'] + data['bondWealth']);
    phone = data['phone'];

    String strExperiences = data['experierceList'];
    if(strExperiences != null && strExperiences != ''){
      experiences = strExperiences.split(',').map((id) => int.parse(id)).toList();
    }

    _streamController.add(this);
  }

  getLocalToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.get('token');
    print('token:$token');
  }

  updateToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    this.token = token;
  }

  clear() async {
    stock = '0.00';
    cash = '0.00';
    phone = '';
    token = null;
    experiences = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _streamController.add(this);
  }
  
  isExperienceDone(int id) {
    return experiences.indexOf(id) != -1;
  }
}
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

  double stock = 0.00;
  double cash = 0.00;
  double total = 0.00;
  String phone = '';
  String name = '';
  String address = '';
  String bankcard = '';
  String token;
  List<int> experiences = [];
  
  Stream<AccountData> get dataStream => _streamController.stream;
  StreamController<AccountData> _streamController = StreamController<AccountData>.broadcast();

  bool isLogin() {
    return token != null;
  }

  update(data){
    cash = Utils.convertDouble(data['cashWealth']);
    stock = Utils.convertDouble(data['bondWealth']);
    total = Utils.convertDouble(data['cashWealth'] + data['bondWealth']);
    phone = data['phone'];
    name = data['name'];
    address = data['address'] ?? '哈哈是';
    bankcard = data['bankcard'] ?? '';

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
    stock = 0.00;
    cash = 0.00;
    total = 0.00;
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

class CashFlowData{
  final int type;
  final String date;
  final double remainingSum;
  final double value;
  CashFlowData(data):
        type = data['type'],
        date = data['recordTime'],
        value = Utils.convertDouble(data['money']),
        remainingSum = Utils.convertDouble(data['beginMoney'] + data['money']);
}

const cashFlowType2Text = ['', '提款取出', '充值存入', '利润提取', '退保证金', '操盘支出', '资产解冻', '资产冻结'];
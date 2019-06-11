import 'package:shared_preferences/shared_preferences.dart';
import 'package:funds/common/utils.dart';

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

  bool isLogin() {
    return token != null;
  }

  init(data){
    stock = Utils.convertDouble(data['bondWealth']);
    cash = Utils.convertDouble(data['cashWealth']);
    total = Utils.convertDouble(data['cashWealth'] + data['bondWealth']);
    phone = data['phone'];

    String strExperiences = data['experierceList'];
    if(strExperiences != null && strExperiences != ''){
      experiences = strExperiences.split(',').map((id) => int.parse(id)).toList();
    }
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
  }

  isExperienceDone(int id) {
    return experiences.indexOf(id) != -1;
  }
}
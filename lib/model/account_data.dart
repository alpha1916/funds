import 'package:shared_preferences/shared_preferences.dart';

class AccountData {
  static AccountData ins;
  static AccountData getInstance() {
    if(ins == null){
      ins = AccountData();
    }
    return ins;
  }

  double stock = 0.0;
  double cash = 0.0;
  String phone = '';
  String token;

  bool isLogin() {
    return token != null;
  }

  init(data){
    stock = data['bondWealth'] ?? 0.00;
    cash = data['cashWealth'];
    phone = data['phone'];
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
    stock = 0.0;
    cash = 0.0;
    phone = '';
    token = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
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
  init(data){
    stock = data['stockWealth'];
    cash = data['cashWealth'];
    phone = data['phone'];
  }

  getLocalToken() async {
  }

  updateToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    this.token = token;
  }
}
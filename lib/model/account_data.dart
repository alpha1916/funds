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
  int integral = 0;
  String phone = '';
  String name = '';
  String address = '';
  bool bindBank;
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
    integral = data['score'];
    name = data['name'];
    address = data['address'] ?? '';
    bindBank = data['bindBank'];

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
    return experiences.contains(id);
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

class MailData{
  final int type;
  final String title;
  final String content;
  final String date;
  MailData(data):
      type = data['mailType'],
      date = data['mailTime'],
      title = data['mailTitle'],
      content = data['mailContent']
  ;

  static getTestData(type){
    var list =  [
      {
        'mailType': 1,
        'mailTime': '2019-06-17 20:00:00',
        'mailTitle': '系统升级维护公告',
        'mailContent': '尊敬的用户：\n\n涨8将于2019年05月18日进行系统升级，预计升级时间2019年05月18日5：00-23：00；升级期间会出现APP、PC和H5端不能访问或闪退现象，升级完毕后会恢复正常；\n\n由于是非交易日，如有用户需紧急联系我们，平台在升级期间会安排客服人员值班，如有疑问可致电400-603-0008 或 关注微信公众号：【涨8投资】--选择客服中心联系客服人员，给您带来的不便敬请谅解，祝您投资愉快！\n\nP.S【微信公众号：zhang8touzi】联系我们噢~~',
      },
      {
        'mailType': 2,
        'mailTime': '2019-06-17 20:00:00',
        'mailTitle': '春节按月打折活动',
        'mailContent': '尊敬的涨8用户： \n\n值新年之际，涨8给您送上新春双重豪礼：\n\n一）新申请月月涨合约管理费8折，另送千元现金红包；\n\n二）月月盈存续合约续约8折返券；\n\n活动时间：1月24日-2月14日；\n\n活动详情入口：点击APP首页“八折新春礼遇+千元红包”即可申请。\n\n\n\n再次祝您投资愉快！',
      },
      {
        'mailType': 3,
        'mailTime': '2019-06-17 20:00:00',
        'mailTitle': '您已成功充值226元，前往我的钱包中查询 >>',
        'mailContent': '系统邮件内容',
      }
    ];
    if(type == 0){
      return list.map((data) => MailData(data)).toList();
    }

    return List.generate(10, (index) => MailData(list[type - 1]));

//    List<List<MailData>> type2List = [];
//    type2List.add(List.generate(10, (_) => MailData(list[0])));
//    type2List.add(List.generate(10, (_) => MailData(list[1])));
//    type2List.add(List.generate(10, (_) => MailData(list[2])));

//    return type2List;
  }
}

class BankCardData{
  final String number;
  final String name;
  final String iconUrl;
  BankCardData(data):
      number = data['bankNo'],
      name = data['bankName'],
      iconUrl = data['imageUrl'];
}
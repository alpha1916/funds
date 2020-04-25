import 'package:shared_preferences/shared_preferences.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';
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
  //是否绑定银行卡
  bool bindBank = false;
  //是否实名认证
  bool certification = false;
  String token;
  bool agreedRisk = false;
  bool hasUnreadMail = false;
  List<int> experiences = [];
  
  Stream<AccountData> get dataStream => _streamController.stream;
  StreamController<AccountData> _streamController = StreamController<AccountData>.broadcast();

  Stream<bool> get unreadMailStream => _unreadMailStreamController.stream;
  StreamController<bool> _unreadMailStreamController = StreamController<bool>.broadcast();

  bool isLogin() {
    return token != null;
  }

  update(data) async{
    cash = Utils.convertDouble(data['cashWealth']);
    stock = Utils.convertDouble(data['bondWealth']);
    total = Utils.convertDouble(data['cashWealth'] + data['bondWealth']);
    phone = data['phone'] ?? '';
    integral = data['score'] ?? 0;
    name = data['name'] ?? '';
    address = data['address'] ?? '';
    bindBank = data['bindBank'] ?? false;
    certification = data['authentication'] ?? false;
    agreedRisk = data['agreeProto'] ?? false;

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

    checkUnreadMail();
  }

  updateToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    this.token = token;

    checkUnreadMail();
  }

  clear() async {
    stock = 0.00;
    cash = 0.00;
    total = 0.00;
    phone = '';
    token = null;
    experiences = [];
    hasUnreadMail = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _streamController.add(this);
  }
  
  isExperienceDone(int id) {
    return experiences.contains(id);
  }

  checkUnreadMail() async{
    ResultData result = await UserRequest.getMailUnreadState();
    if(result.success && result.data){
      hasUnreadMail = true;
      _unreadMailStreamController.add(hasUnreadMail);
    }
  }

  readMails() async{
    if(!hasUnreadMail)
      return;

    var result = await UserRequest.readMails();
    if(result.success){
      hasUnreadMail = false;
      _unreadMailStreamController.add(hasUnreadMail);
    }
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
        remainingSum = Utils.convertDouble(data['endMoney'])
  ;
}

final Map<int, String> integralType2Title = {
  1: '签到送积分',
  2: '积分兑换优惠券',
  3: '上传头像',
  4: '担保费奖励',
  5: '首次操盘',
  6: '绑定银行卡',
  7: '实名认证',
  8: '开合约',
  9: '续合约',
};
class IntegralFlowData{
  final int type;
  final String date;
  final int remainingSum;
  final int value;
  String get title => integralType2Title[type] ?? '未知名称$type';
  IntegralFlowData(data):
        type = data['scoreType'],
        date = data['recordTime'],
        value = data['score'],
        remainingSum = data['beginScore'] + data['score'];
}

const Map<int, String> cashFlowType2Text = {
  1: '提款取出',
  2: '充值存入',
  3: '利润提取',
  4: '退保证金',
  5: '操盘支出',
  6: '资产解冻',
  7: '资产冻结',
  8: '担保费用',
  9: '追加保证金',
  10: '利息',
  11: '调增',
};

enum MailType{
  all,
  notice,
  activity,
  system,
}

class MailData{
  final int type;
  final String title;
  final String content;
  final String date;
  final int subtype;
  final String extra;
  MailData(data):
      type = data['mailType'],
      date = data['mailTime'],
      title = data['mailTitle'],
      content = data['mailContent'],
      subtype = data['gotoId'],
      extra = data['gotoParam']
  ;
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

class SignData {
  final int signedDays;
  final bool isSignedToday;
  SignData(data):
      signedDays = data['signDay'],
      isSignedToday = data['todaySign']
  ;
}

String getRewardText(type, value){
  return '+$value${rewardType2Name[type]}';
}

class TaskId{
  static const int register = 1;
  static const int certification = 2;
  static const int bindCard = 3;
  static const int applyContract = 4;
}
//taskStatus：1是未完成，2是已完成
final Map<int, String> rewardType2Name = {
  1: '元优惠券礼包',
  2: '积分',
  3: '元优惠券x1',
};
class TaskData {
  final int id;
  final String title;
  final int rewardType;
  final int rewardValue;
  final bool done;
  final String tips;
  String get strReward => '+$rewardValue${rewardType2Name[rewardType] ?? '未知奖励类型$rewardType'}';
  
  TaskData(data):
        id = data['taskId'],
        title = data['taskName'],
        rewardType = data['rewardType'],
        rewardValue = data['rewardValue'],
        tips = data['remarks'] ?? '',
        done = data['taskStatus'] == 2
  ;

}

final Map<int, String> rechargeState2Name = {
  1: '处理中',
  2: '已完成',
  3: '已驳回',
};
class RechargeData{
  final double value;
  final int state;
  final String date;

  String get strState => rechargeState2Name[state];
  RechargeData(data):
        state = data['status'],
        value = Utils.convertDouble(data['money']),
        date = data['createTime'];
}
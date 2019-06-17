import 'package:funds/model/coupon_data.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';

class ExperienceInfoData {
  final int id;
  final int capital;
  final int contractTimes;
  final int loanAmount;
  final String title;
  final String timeLimit;
  final String riskTips;
  bool done = false;
  ExperienceInfoData(data):
        id = data['id'],
        contractTimes = data['contractTimes'],
        loanAmount = data['loanAmount'],
        capital = data['loanAmount'] ~/ data['contractTimes'],
        title = data['experienceTypename'],
        timeLimit = data['timeLimitName'],
        riskTips = data['riskName']
  ;
//  "id": 1,
//  "contractType": 1,
//  "contractTimes": 20,
//  "loanAmount": 2000,
//  "experienceType": 1,
//  "experienceTypename": "免费体验",
//  "timeLimitName": "2个交易日",
//  "riskName": "亏损全赔付"
}

class ContractApplyDetailData {
  static int normalType = 0;
  static int experienceType = 1;

  int contractType = normalType;
  String title;//标题
  int capital;//杠杆本金
  int total;//合约金额
  String period;//持仓时间
  List<CouponData> coupons = [];

  final int profit;//盈利分配
  final double cost;//管理费
  final int cordon;//警戒线
  final int cut;//止损线
  final String date;//开始交易时间
  final String holdTips;//单票持仓

  //体验合约专用
  int id;
  //普通合约专用
  int type;
  int times;
  int loadAmount;
  ContractApplyDetailData(data):
//        title = data['title'],
//        capital = data['capital'],

        profit = data['profitRate'],
        cost = Utils.convertDouble(data['management']),
        cordon = data['warnLine'],
        cut = data['stopLossLine'],
        date = data['tradeStartTime'],

        holdTips = data['holdTips']

//        period = data['period'],
//        total = data['total'],
//        coupons = data['coupons'].map<CouponData>((couponData){
//          return CouponData(couponData);
//        }).toList()
  ;

}

//class ContractData {
//  final int type;
//  final String title;
//  final bool ongoing;
//  final String startDate;
//  final String endDate;
//  final double total;
//  final double contract;
//  final double profit;
//  ContractData(data):
//        type = data['type'],
//        title = data['title'],
//        ongoing = data['ongoing'],
//        startDate = data['startDate'],
//        endDate = data['endDate'],
//        total = data['total'],
//        contract = data['contract'],
//        profit = data['profit']
//  ;
//}
//ContractItemView(this.type, this.title, this.ongoing, this.startDate, this.endDate,
//this.total, this.contract, this.profit

class ContractApplyItemData{
  final int type;
  final String title;//标题
  final String interest;
  final String timeLimit;
  final int min;
  final int max;
  final List<int> timesList;
  ContractApplyItemData(data):
        type = data['type'],
        title = data['name'],
        timeLimit = data['timeLimitName'],
        interest = data['managementName'],
        min = data['minMoney'],
        max = data['maxMoney'],
        timesList = data['lever'].split(',').map<int>((times) => int.parse(times)).toList();
}


class ContractData {
  final double contractMoney;//合约金额
  final String contractNumber;//合约信息
  final double profit;//累计盈亏
  final double capital;//杠杆本金
  final double cash;//可提现金
  final double operateMoney;//操盘金额
  final String beginTime;
  final String endTime;
  final double loan;//借款金额
  final double totalMoney;//资产总值
  final double cost;//管理费用
  final double usableMoney;//可用现金
  final int profitRate;//盈利分配
  final double realCost;//实收管理费

  final String title;//标题
  final int days;//使用天数
  final int cordon;//警戒线
  final int cut;//止损线
  final bool ongoing;//操盘中

  //历史合约专用
  final double returnMoney;//结束退还本金

  ContractData(data):
        contractNumber = data['contractNumber'],
        contractMoney = Utils.convertDouble(data['contractMoney']),
        profit = data['profit'],
        realCost = Utils.convertDouble(data['realManagement']),
        profitRate = data['profitRate'],
        returnMoney = Utils.convertDouble(data['returnMoney']),
        cash = Utils.convertDouble(data['cash']),
        operateMoney = data['operateMoney'],
        capital = Utils.convertDouble(data['principal']),
        loan = Utils.convertDouble(data['loanAmount']),
        cost = Utils.convertDouble(data['management']),
        beginTime = data['beginTime'].split(' ')[0],
        endTime = data['endTime'].split(' ')[0],
        totalMoney = Utils.convertDouble(data['totalMoney']),
        usableMoney = data['availableMoney'],

        title = data['title'],
        cordon = data['warnLine'],
        cut = data['stopLossLine'],
        days = data['useDay'],
        ongoing = data['stat'] == 1
  ;

}

final tradeFlowStatus = ['未知', '已成交'];

class TradeFlowData{
  final String title;
  final String code;
  final double price;
  final int count;
  final String strDay;
  final String strTime;
  final String strType;
  final int type;
  final String strState;
  TradeFlowData(data):
      title = data['secShortname'],
      code = data['secCode'],
      count = data['count'],
      price = Utils.convertDouble(data['price']),
      type = data['type'],
      strType = data['type'] == TradeType.buy ? '买入' : '卖出',
      strState = tradeFlowStatus[data['status']],
      strDay = data['recordTime'].split(' ')[0],
      strTime = data['recordTime'].split(' ')[1];
}

//class ExperienceContractData {
//  final int management;
//  final int contractTimes;
//  final int loanAmount;
//  ExperienceContractData(data):
//      management = data['management'],
//      cut = data['stopLossLine'],
//      cordon = data['warnLine']
//  ;
////  "management": 0,
////  "stopLossLine": 0,
////  "warnLine": 0
//}
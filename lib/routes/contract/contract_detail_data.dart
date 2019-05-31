import 'package:funds/model/coupon_data.dart';

class ContractApplyDetailData {
  final String title;//标题
  final int total;//合约金额
  final int profit;//盈利分配
  final int capital;//杠杆本金
  final int cost;//管理费
  final int cordon;//警戒线
  final int cut;//止损线
  final String date;//开始交易时间
  final String holdTips;//单票持仓
  final String period;//持仓时间
  final List<CouponData> coupons;
  ContractApplyDetailData(data):
      title = data['title'],
      profit = data['profit'],
      capital = data['capital'],
      cost = data['cost'],
      cordon = data['cordon'],
      cut = data['cut'],
      date = data['date'],
      holdTips = data['holdTips'],
      period = data['period'],
      total = data['total'],
      coupons = data['coupons'].map<CouponData>((couponData){
        return CouponData(couponData);
      }).toList()
  ;

}
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

class ContractData {
  final int type;
  final String title;
  final bool ongoing;
  final String startDate;
  final String endDate;
  final double total;
  final double contract;
  final double profit;
  ContractData(data):
        type = data['type'],
        title = data['title'],
        ongoing = data['ongoing'],
        startDate = data['startDate'],
        endDate = data['endDate'],
        total = data['total'],
        contract = data['contract'],
        profit = data['profit']
  ;
}
//ContractItemView(this.type, this.title, this.ongoing, this.startDate, this.endDate,
//this.total, this.contract, this.profit

class ContractApplyItemData{
  final int type;
  final String title;//标题
  final String interest;
  final int min;
  final int max;
  final List<int> timesList;
  ContractApplyItemData(data):
        type = data['type'],
        title = data['title'],
        interest = data['interest'],
        min = data['min'],
        max = data['max'],
        timesList = data['timesList'];
}


class CurrentContractDetailData {
  final String title;//标题
  final double total;//合约金额
  final double profit;//累计盈亏
  final double cash;//可提现金
  final double cost;//管理费用
  final String info;//合约信息
  final double capital;//杠杆本金
  final double loan;//借款金额
  final double contract;//合约金额
  final double stocks;//合约金额
  final int days;//使用天数
  final double cordon;//警戒线
  final double cut;//止损线
  CurrentContractDetailData(data):
        title = data['title'],
        total = data['total'],
        cash = data['cash'],
        profit = data['profit'],
        capital = data['capital'],
        cost = data['cost'],
        cordon = data['cordon'],
        info = data['info'],
        loan = data['loan'],
        contract = data['contract'],
        cut = data['cut'],
        stocks = data['stocks'],
        days = data['days']
  ;

}
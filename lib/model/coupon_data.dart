class CouponData {
  final String title;//标题
  final int cost;//优惠值
  final String date;//开始交易时间
  CouponData(data):
        title = data['title'],
        cost = data['cost'],
        date = data['date'];
}

//{'cost': 50, 'title': '管理费抵用券', 'date': '2019-06-29'},
class CouponData {
  final int id;
  final String title;//标题
  final int cost;//优惠值
  final String expireDate;//开始交易时间
  final int integral;//兑换需要积分
  CouponData(data):
        id = data['id'],
        title = data['title'] ?? '管理费抵用券',
        cost = data['ticketValue'],
        integral = data['score'],
        expireDate = data['expireDate'];
}

//{'cost': 50, 'title': '管理费抵用券', 'date': '2019-06-29'},
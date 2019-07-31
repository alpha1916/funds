class CouponData {
  final int id;
  final String title;//标题
  final int cost;//优惠值
  final String expireDate;//开始交易时间
  final int integral;//兑换需要积分
  CouponData.fromShopData(data):
        id = data['id'],
        title = data['name'],
        cost = data['ticketValue'],
        integral = data['score'],
        expireDate = null
  ;

  CouponData.fromSelfData(data):
      id = data['id'],
      expireDate = data['time'],
      title = data['name'],
      cost = data['value'],
      integral = null
  ;
}

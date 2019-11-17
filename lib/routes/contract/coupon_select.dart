import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/coupon_data.dart';

class CouponSelectPage extends StatelessWidget {
  CouponSelectPage(this.dataList, this.selectedId);

  final List<CouponData> dataList;
  final int selectedId;
  @override
  Widget build(BuildContext context) {
    double realWidth = MediaQuery.of(context).size.width;
    final margin = a.px16;
    final itemHeight = (realWidth - margin * 2) * 0.2;
    return Scaffold(
      appBar: AppBar(
        title: Text('选用抵用券'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: dataList.map<Widget>((data) {
              return _buildItem(context, data, itemHeight, margin);
            }).toList(),
          ),
        )
      )
    );
  }

  _getBGPath(cost) {
    if(cost < 200){
      return CustomIcons.couponBG1;
    }else if(cost < 1000){
      return CustomIcons.couponBG2;
    }
    return CustomIcons.couponBG3;
  }

  _buildItem(BuildContext context, CouponData data, itemHeight, margin){
    List<Widget> list = [
      Container(
        width: itemHeight * 282 / 134,
        height: itemHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBGPath(data.cost)),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(width: a.px12,),
            Text('￥\n', style: TextStyle(color: Colors.white, fontSize: a.px25)),
            Expanded(child: Container(),),
            Text(data.cost.toString(), style: TextStyle(color: Colors.white, fontSize: a.px36)),
            SizedBox(width: a.px12,),
          ],
        ),
      ),
      SizedBox(width: a.px10),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('担保费抵用券', style: TextStyle(color: Colors.black87, fontSize: a.px15, fontWeight: FontWeight.w500)),
            SizedBox(height: a.px3,),
            Text('有效期至：${data.expireDate}', style: TextStyle(color: Colors.black54, fontSize: a.px14)),
          ],
        ),
      ),
    ];

    if(selectedId == data.id){
      list.add(Expanded(child: Container()));
      list.add(Icon(Icons.check));
      list.add(SizedBox(width: a.px5));
    }

    return InkWell(
      child: Container(
        height: itemHeight,
        margin: EdgeInsets.fromLTRB(margin, margin, margin, 0),
        color: Colors.white,
        child: Row(
          children: list,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(data);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/account_data.dart';

//http://www.cmbchina.com/cmb.ico?
class BankSelectPage extends StatelessWidget {
  final String selectedBank;
  final List<BankCardData>dataList;

  BankSelectPage(this.selectedBank, this.dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('选择银行'),
      ),
      body: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: dataList.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var data = dataList[index];
    String name = data.name;
    String iconUrl = data.iconUrl;

    List<Widget> children = [
      Image.network(iconUrl, height: a.px26),
      SizedBox(width: a.px10,),
      Text(name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: a.px16),),
    ];

    if(selectedBank == name){
      children.add(Utils.expanded());
      children.add(Icon(Icons.check));
      children.add(SizedBox(width: a.px24,));
    }

    return InkWell(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: a.px24),
        child: Column(
          children: <Widget>[
            SizedBox(height: a.px20,),
            Row(children: children),
            SizedBox(height: a.px20,),
            Divider(height: 1),
          ],
        ),
      ),
      onTap: () {
        Utils.navigatePop(name);
      },
    );
  }
}


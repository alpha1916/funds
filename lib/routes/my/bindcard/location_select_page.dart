import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';

class LocationSelectPage extends StatelessWidget {
  final String title;
  final dataList;

  LocationSelectPage(this.title, this.dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(title),
      ),
      body: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: dataList.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var data = dataList[index];
    String name = data['name'];

    return InkWell(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: a.px24),
        child: Column(
          children: <Widget>[
            SizedBox(height: a.px16,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: a.px16),),
            ),
            SizedBox(height: a.px16,),
            Divider(height: 1),
          ],
        ),
      ),
      onTap: () {
        Utils.navigatePop(data);
      },
    );
  }
}

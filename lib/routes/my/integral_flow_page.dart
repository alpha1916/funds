import 'package:flutter/material.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';

class IntegralFlowPage extends StatefulWidget {
  @override
  _IntegralFlowPageState createState() => _IntegralFlowPageState();
}

class _IntegralFlowPageState extends State<IntegralFlowPage> {
  List<IntegralFlowData> _dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  _refresh() async {
    var result = await UserRequest.getIntegralFlow(0, 100);
    if(result.success){
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('积分流水'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index){
          IntegralFlowData data = _dataList[index];
          String strValue = data.value > 0 ? '+${data.value}' : data.value.toString();
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(a.px16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(data.title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500),),
                        Text(strValue, style: TextStyle(fontSize: a.px15, color: Utils.getProfitColor(data.value), fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(height: a.px6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('积分余额：${data.remainingSum}', style: TextStyle(fontSize: a.px15)),
                        Text(data.date, style: TextStyle(fontSize: a.px15)),
                      ],
                    )
                  ],
                ),
              ),
              Divider(height: 0, indent: a.px16,),
            ],
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }
}

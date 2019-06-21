import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';

class MyTrialPage extends StatefulWidget {
  @override
  _MyTrialPageState createState() => _MyTrialPageState();
}

class _MyTrialPageState extends State<MyTrialPage> {
  List<ContractData> _dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
    ResultData result = await ExperienceRequest.getContractList();
    if(mounted && result.success){
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_dataList == null || _dataList.length == 0){
      return _buildNoDataView();
    }
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            margin: EdgeInsets.only(top: a.px10),
//            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(ContractType.trial, data, () {
              print('select $index');
              if(data.ongoing){
                Utils.navigateTo(CurrentContractDetail(data));
              }
            }),
            alignment: Alignment.center,
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _buildNoDataView() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: a.px20, bottom: a.px30),
            color: Colors.white,
            child: Center(
              child: Text('当前没有数据', style: TextStyle(fontSize: a.px16, color: Colors.black54)),
            )
        ),
      ],
    );
  }
}

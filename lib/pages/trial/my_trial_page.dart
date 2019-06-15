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
}

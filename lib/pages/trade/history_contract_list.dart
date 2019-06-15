import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/network/http_request.dart';

class HistoryContractListPage extends StatefulWidget {
  @override
  _HistoryContractListPageState createState() => _HistoryContractListPageState();
}

class _HistoryContractListPageState extends State<HistoryContractListPage> {
  List<ContractData> _dataList = [];

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
    ResultData result = await ContractRequest.getContractList(1);
    if(mounted && result.success) {
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.background1,
//      child: Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(ContractType.history, data, () {
              print('select $index');
            }),
            alignment: Alignment.center,
          );
        },
        itemCount: _dataList.length,
      ),
//      ),
    );
  }
}


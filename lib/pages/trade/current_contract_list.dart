import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import '../contract_item_view.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';
import 'package:funds/network/http_request.dart';

class CurrentContractListPage extends StatefulWidget {
  @override
  _CurrentContractListPageState createState() => _CurrentContractListPageState();
}

class _CurrentContractListPageState extends State<CurrentContractListPage> {
  List<ContractData> _dataList = [];

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
    _dataList = await HttpRequest.getCurrentContractList();

    if(mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final realWidth = MediaQuery.of(context).size.width;

    return Container(
      color: CustomColors.background1,
//      child: Expanded(
        child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(data, realWidth, (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_){
                  return CurrentContractDetail();
                },
              ));
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


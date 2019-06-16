import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/routes/contract/contract_apply.dart';

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
    ResultData result = await ContractRequest.getContractList(0);
    if(mounted && result.success) {
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_dataList == null || _dataList.length == 0){
      return _buildPromoteView();
    }
    return Container(
      color: CustomColors.background1,
        child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            padding: EdgeInsets.only(bottom: a.px10),
            child: ContractItemView(
              ContractType.current,
              data,
              (){
                Utils.navigateTo(CurrentContractDetail(data));
              }
            ),
            alignment: Alignment.center,
          );
        },
          itemCount: _dataList.length,
        ),
    );
  }

  _buildPromoteView() {
    return Container(
      color: CustomColors.background1,
      child: Container(
        height: a.px50,
        padding: EdgeInsets.symmetric(vertical: a.px20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('当前没有操盘中的合约', style: TextStyle(fontSize: a.px14, color: Colors.black26)),
            FlatButton(
              child: Text(
                '申请合约享受盈利翻倍',
                style: TextStyle(
                  fontSize: a.px16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () async{
                ResultData result = await ContractRequest.getConfigs();
                if(mounted && result.success){
                  Utils.navigateTo(ContractApplyPage(result.data));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


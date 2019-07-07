import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';
import 'package:funds/pages/trade/history_trial_detail.dart';

class MyTrialPage extends StatefulWidget {
  final onPressedPromote;
  MyTrialPage(this.onPressedPromote);
  @override
  _MyTrialPageState createState() => _MyTrialPageState();
}

class _MyTrialPageState extends State<MyTrialPage> {
  List<ContractData> _dataList;
  _MyTrialPageState();

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
    if(_dataList == null){
      return Container();
    }else if(_dataList.length == 0){
      return _buildPromoteView();
    }

    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            margin: EdgeInsets.only(top: a.px10),
//            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(ContractType.trial, data, () {
              print('select $index, ongoing:${data.ongoing}');
              if(data.ongoing)
                Utils.navigateTo(CurrentContractDetail(data));
              else
                Utils.navigateTo(HistoryTrialDetail(data));
            }),
            alignment: Alignment.center,
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _buildPromoteView() {
    return Container(
        padding: EdgeInsets.only(top: a.px20),
        color: Colors.white,
        child: Center(
          child: Column(
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
                onPressed: widget.onPressedPromote,
              ),
            ],
          ),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/routes/contract/contract_apply.dart';
import 'package:funds/model/contract_data.dart';


class FundsView extends StatefulWidget {
  @override
  _FundsViewState createState() => _FundsViewState();
}

class _FundsViewState extends State<FundsView> {
  List<ContractApplyItemData> _dataList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('配资'),
        leading: Utils.buildServiceIconButton(context),
        actions: [
          Utils.buildMyTradeButton(context),
        ],
      ),
      body: Column(
        children: <Widget>[
          _itemListView(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
    ResultData result = await ContractRequest.getConfigs();
    if(mounted && result.success){
      setState(() {
        _dataList = result.data;
      });
    }
  }

  _itemListView () {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            child: _ItemView(data, _onClickedItem),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _onClickedItem(int type) async{
    print('apply item:$type');
    Utils.navigateTo(ContractApplyPage(_dataList, type));
  }
}

class _ItemView extends StatelessWidget {
  final ContractApplyItemData data;
  final onPressed;

  createView() {
    final String trayImagePath = CustomIcons.fundsPeriodTrayPrefix + data.type.toString() + '.png';
    return Container(
      child: Image.asset(trayImagePath,
          fit: BoxFit.fitWidth
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: createView(),
      onTap: () {
        this.onPressed(data.type);
      },
    );
  }

  _ItemView(this.data, this.onPressed);
}
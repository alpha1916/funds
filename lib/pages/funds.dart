import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/routes/contract/contract_apply.dart';
import 'package:funds/network/contract_request.dart';


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
        title:Text('交易'),
        leading: Utils.buildServiceIconButton(context),
        actions: [
          Utils.buildMyTradeButton(),
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
          final String trayImagePath = CustomIcons.fundsPeriodTrayPrefix + data.type.toString() + '.png';
          return Container(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    trayImagePath,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 0,
                    left: index.isOdd ? null : 0,
                    right: index.isOdd ? a.px6: null,
                    child: _buildItemTextView(data),
                  )
                ],
              ),
              onTap: () => _onClickedItem(data.type),
            ),
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _buildItemTextView(ContractApplyItemData data) {
    TextStyle normalTextStyle = TextStyle(
      fontSize: a.px16,
      color: Colors.white,
    );

    TextStyle numberStyle = TextStyle(
      fontSize: a.px16,
      color: Color.fromARGB(255, 253, 200, 61),
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(a.px17, a.px48, a.px17, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(data.title, style: TextStyle(fontSize: a.px36, color: Colors.white, fontWeight: FontWeight.w500)),
              SizedBox(width: a.px10),
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: a.px15 * data.interest.length * 1.1,
                    height: a.px24,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 63, 132),
                      borderRadius: BorderRadius.all(Radius.circular(a.px4)),
                    ),
                    child: Text(data.interest, style: TextStyle(fontSize: a.px15, color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                  Text(' ', style: TextStyle(fontSize: a.px7)),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text('${data.min}元', style: numberStyle),
              Text(' 起', style: normalTextStyle),
              SizedBox(width: a.px12),
              Text('${data.minRate}-${data.maxRate}倍', style: numberStyle),
              Text(' 杠杆', style: normalTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  _onClickedItem(int type) async{
    print('apply item:$type');
    Utils.navigateTo(ContractApplyPage(_dataList, type));
  }
}
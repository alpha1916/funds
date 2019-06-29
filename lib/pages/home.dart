import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/routes/contract/contract_apply.dart';

import 'package:funds/model/contract_data.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String mail = CustomIcons.mail0;
  List<ContractApplyItemData> _dataList = [];

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

  @override
  Widget build(BuildContext context) {
    Widget banner1 = new Image.asset(
      CustomIcons.homeBanner1,
      fit: BoxFit.fitWidth,
    );

    Widget banner2 = new Image.asset(
      CustomIcons.homeBanner2,
      fit: BoxFit.cover,
    );

//    return ContractApplyDelayPage();

    return Scaffold(
      appBar: AppBar(
        title:Text('首页'),
        leading: Utils.buildServiceIconButton(context),
        actions: [
          Utils.buildMailIconButton(),
        ],
      ),
      body: Column(
        children: [
          banner1,
          banner2,
          SizedBox(height: a.px12),
          _itemListView(),
        ]
      )
    );

  }

  _itemListView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return _buildItem(data);
        },
        itemCount: _dataList.length,
      ),
    );
  }

  _buildItem(ContractApplyItemData data){
    TextStyle titleStyle = TextStyle(
      fontSize: a.px18,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );

    TextStyle normalTextStyle = TextStyle(
      fontSize: a.px16,
      color: Colors.black87,
    );

    TextStyle numberStyle = TextStyle(
      fontSize: a.px18,
      color: CustomColors.red,
      fontWeight: FontWeight.w500,
    );

    final int minRate = data.timesList.first;
    final int maxRate = data.timesList.last;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            dense:true,
            leading: Image.asset('${CustomIcons.homePeriodPrefix}${data.type}.png', height: a.px48),
            title: Row(
              children: <Widget>[
                Text(data.title, style: titleStyle),
                SizedBox(width: a.px20,),
                Text(data.interest, style: normalTextStyle),
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Text('${data.min}元', style: numberStyle),
                Text(' 起', style: normalTextStyle),
                SizedBox(width: a.px20,),
                Text('$minRate-$maxRate倍', style: numberStyle),
                Text(' 杠杆', style: normalTextStyle),
              ],
            ),
            trailing: Utils.buildForwardIcon(),
            contentPadding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px4),
            onTap: (){
              Utils.navigateTo(ContractApplyPage(_dataList, data.type));
            },
          ),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
        ],
      ),
    );
  }
}
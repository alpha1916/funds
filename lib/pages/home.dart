import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/contract/contract_apply.dart';

import 'package:funds/model/contract_data.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String mail = CustomIcons.mail0;
  Map<int, List<ContractApplyItemData>> configs;
  List<ContractApplyItemData> _dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
//    if(Global.hasUnreadMail == null){
//      ResultData result = await UserRequest.getMailUnreadState();
//      if(result.success)
//        Global.hasUnreadMail = true;//result.data;
//    }
    ResultData result = await ContractRequest.getConfigs();
    if(result.success){
      setState(() {
        configs = result.data;
        _dataList = configs[Board.main];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    return ContractApplyDelayPage();
    List<Widget> list = [
      InkWell(
        child: Image.asset(CustomIcons.homeBanner1, fit: BoxFit.cover),
        onTap: () {},
      ),
      SizedBox(height: a.px12),
      InkWell(
        child: Image.asset(CustomIcons.homeBanner2, fit: BoxFit.cover),
        onTap: () => Utils.appMainTabSwitch(AppTabIndex.experience),
      ),
      SizedBox(height: a.px12),
    ];
    list.addAll(_dataList.map<Widget>((data) => _buildItem(data)).toList());

    return Scaffold(
      appBar: AppBar(
        title:Text('首页'),
        leading: Utils.buildServiceIconButton(context),
        actions: [
          Utils.buildMailIconButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: list,
        ),
      )
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
                Text('${data.minRate}-${data.maxRate}倍', style: numberStyle),
                Text(' 杠杆', style: normalTextStyle),
              ],
            ),
            trailing: Utils.buildForwardIcon(),
            contentPadding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px4),
            onTap: (){
              Utils.navigateTo(ContractApplyPage(configs, data.type));
            },
          ),
          Divider(height: a.px1, indent: a.px16),
        ],
      ),
    );
  }
}
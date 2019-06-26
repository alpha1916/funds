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
      body: Container(
        color: CustomColors.background1,
        //首页内容
        child: Column(
          children: [
            banner1,
            banner2,
            SizedBox(height: a.px12),
            _itemListView(),
          ]
        )
      ),
    );

  }

  _itemListView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return _ItemView(data, _onClickedItem);
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
  _ItemView(this.data, this.onPressed);

  Widget getItemIcon(type) {
    final String path = CustomIcons.homePeriodPrefix + type.toString() + '.png';
    return Image.asset(path, width: a.px48, height: a.px48);
  }

  createView () {
    TextStyle homeItemStyle1 = TextStyle(
      fontSize: a.px18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    TextStyle homeItemStyle2 = TextStyle(
      fontSize: a.px16,
      color: Colors.black87,
    );

    TextStyle homeItemStyle3 = TextStyle(
      fontSize: a.px18,
      color: Colors.red,
      fontWeight: FontWeight.w500,
    );
    
    final int minRate = data.timesList.first;
    final int maxRate = data.timesList.last;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, top:a.px10),
//      child: getItemIcon(type),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              //周期图标
              getItemIcon(data.type),
              //文本内容
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: a.px10, right: a.px10, bottom: a.px5),
                          child: Text(data.title, style: homeItemStyle1),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: a.px10, right: a.px10, bottom: a.px5),
                          child: Text(data.interest, style: homeItemStyle2),
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: a.px10, right: a.px3),
                          child: Text('${data.min}元', style: homeItemStyle3),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: a.px8),
                          child: Text('起', style: homeItemStyle2),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: a.px10, right: a.px3),
                          child: Text('$minRate-$maxRate倍', style: homeItemStyle3),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: a.px10),
                          child: Text('杠杆', style: homeItemStyle2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //右箭头
              Icon(Icons.arrow_forward_ios, color: Colors.black26,),
              SizedBox(width: a.px16),
            ],
          ),
          SizedBox(height: a.px10),
          Utils.buildSplitLine(height: a.px1)
        ],
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
}
import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/routes/account/login_page.dart';
import 'package:funds/routes/contract/contract_apply.dart';
import 'package:funds/routes/contract/contract_apply_detail.dart';
import 'package:funds/routes/contract/coupon_select.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';
import 'package:funds/routes/trade/stock_trade_main.dart';
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
    _dataList = await HttpRequest.getApplyItemList();

    if(mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget iconMail = Image.asset(mail, width: CustomSize.icon, height: CustomSize.icon);

    Widget banner1 = new Image.asset(
      CustomIcons.homeBanner1,
      fit: BoxFit.fitWidth,
    );

    Widget banner2 = new Image.asset(
      CustomIcons.homeBanner2,
      fit: BoxFit.cover,
    );

    return StockTradeMainPage('测试');
//    return CurrentContractDetail();
//    return CouponSelectPage(CouponSelectPage.getTestData());
//    return ContractApplyPage();
//    return ContractApplyDetailPage(ContractApplyDetailPage.getTestData());

    return Scaffold(
      appBar: AppBar(
        title:Text('首页'),
        leading: Utils.buildServiceIconButton(context),
        actions: [
          IconButton(
              icon: iconMail,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_){
                      return CurrentContractDetail();
                    },
                ));
              },
          ),
        ],
      ),
      body: Container(
        color: CustomColors.background1,
        //首页内容
        child: Column(
          children: [
            banner1,
            banner2,
//            Container(height: 12),
            const SizedBox(height: 12),
            _itemListView(),
          ]
        )
      ),
    );

  }

  _onPressedMail() {
    print('press mail');
  }

  _itemListView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            child: _ItemView(data),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final ContractApplyItemData data;
  _ItemView(this.data);

  Widget getItemIcon(type) {
    final String path = CustomIcons.homePeriodPrefix + type.toString() + '.png';
    return Image.asset(path, width: 48, height: 48);
  }

  createView () {
    final int minRate = data.timesList.first;
    final int maxRate = data.timesList.last;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top:10, bottom: 10),
//      child: getItemIcon(type),
      child: Row(
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
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: Text(data.title, style: CustomStyles.homeItemStyle1),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                      child: Text(data.interest, style: CustomStyles.homeItemStyle2),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 3),
                      child: Text('${data.min}元', style: CustomStyles.homeItemStyle3),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text('起', style: CustomStyles.homeItemStyle2),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 3),
                      child: Text('$minRate-$maxRate倍', style: CustomStyles.homeItemStyle3),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('杠杆', style: CustomStyles.homeItemStyle2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //右箭头
          Icon(Icons.arrow_forward_ios, color: Colors.black26,),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: createView(),
      onTap: () async{
        final applyItemDataList = await HttpRequest.getApplyItemList();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ContractApplyPage(applyItemDataList, data.type)),
        );
      },
    );
  }
}
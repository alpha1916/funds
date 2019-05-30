import 'package:flutter/material.dart';
import '../common/constants.dart';
import 'package:funds/routes/account/login_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String mail = CustomIcons.mail0;
  List<Map<String, int>> _dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataList = [
      {'type': 0, 'startPrice': 2000, 'minRate': 3, 'maxRate': 10},
      {'type': 1, 'startPrice': 2000, 'minRate': 3, 'maxRate': 8},
      {'type': 2, 'startPrice': 2000, 'minRate': 3, 'maxRate': 6},
      {'type': 3, 'startPrice': 1000, 'minRate': 6, 'maxRate': 8},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Widget iconService = Image.asset(CustomIcons.service, width: CustomSize.icon, height: CustomSize.icon);
    final Widget iconMail = Image.asset(mail, width: CustomSize.icon, height: CustomSize.icon);

    Widget banner1 = new Image.asset(
      CustomIcons.homeBanner1,
      fit: BoxFit.fitWidth,
    );

    Widget banner2 = new Image.asset(
      CustomIcons.homeBanner2,
      fit: BoxFit.cover,
    );

    return LoginPage();

    return Scaffold(
      appBar: AppBar(
        title:Text('首页'),
        leading: IconButton(
            icon: iconService,
            onPressed: _onPressService,
        ),
        actions: [
          IconButton(
              icon: iconMail,
              onPressed: _onPressedMail,
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


  _onPressService() {
    print('press service');
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (_) {
        return LoginPage();
      }),
    );
    print('press service2');
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
            child: _ItemView(data['type'], data['startPrice'], data['minRate'], data['maxRate']),
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
  final int type;
  final int minRate;
  final int maxRate;
  final int startPrice;
  _ItemView(this.type, this.startPrice, this.minRate, this.maxRate);

  Widget getItemIcon(type) {
    final String path = CustomIcons.homePeriodPrefix + type.toString() + '.png';
    return Image.asset(path, width: 48, height: 48);
  }

  createView () {
    final texts = Constants.itemTextList[type];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top:10, bottom: 10),
//      child: getItemIcon(type),
      child: Row(
        children: [
          //周期图标
          getItemIcon(type),
          //文本内容
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                      child: Text(texts['title'], style: CustomStyles.homeItemStyle1),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                      child: Text(texts['interest'], style: CustomStyles.homeItemStyle2),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 3),
                      child: Text('$startPrice元', style: CustomStyles.homeItemStyle3),
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
          Image.asset(CustomIcons.rightArrow, width: 16, height: 16),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    print('item view type:$type');
    return GestureDetector(
      child: createView(),
      onTap: () {
        print('press item type:$type');
      },
    );
  }
}
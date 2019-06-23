import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/user_request.dart';
import 'bank_select_page.dart';
import 'location_select_page.dart';

import 'package:funds/model/location_data.dart';

class BindBankCardPage extends StatefulWidget {
  @override
  _BindBankCardPageState createState() => _BindBankCardPageState();
}

class _BindBankCardPageState extends State<BindBankCardPage> {
  final forwardIcon = Utils.buildForwardIcon();
  final splitLine = Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16));

  String bank;
  String city;
  MapEntry<String, String> selectProvinceData;

//  provinceDataList = provinceData.map((key, value) => {key: value}).toList();
  @override
  Widget build(BuildContext context) {
    print('buid');
    var fontSize = a.px16;
    return Scaffold(
      appBar: AppBar(
        title:Text('绑定银行卡'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            SizedBox(height: 12,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('开户人', style: TextStyle(fontSize: fontSize),),
                  Text(AccountData.getInstance().name, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            splitLine,
            _buildSettableItem('选择银行', bank, _onPressedBank),
            splitLine,
            _buildSettableItem('开户行所在省', selectProvinceData?.value, _onPressedProvince),
            splitLine,
            _buildSettableItem('开户行所在区', city, _onPressedCity),
            splitLine,
            _buildLocationView(),
            splitLine,
            _buildCardView(),
            SizedBox(height: 12,),
            _buildPhoneView(),
            _buildTipsView(),
            Utils.expanded(),
            _buildOKButton(),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _buildSettableItem(title, value, onPressed){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px16),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: a.px16),),
            Utils.expanded(),
            Text(value ?? '请选择', style: TextStyle(fontSize: a.px16),),
            forwardIcon,
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _buildTipsView() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('为了您的资金安全，请选择常用的银行卡，确保为本人使用，仅限绑定一张银行卡', style: TextStyle(fontSize: a.px14, fontWeight: FontWeight.w500),),
        )
    );
  }

  final TextEditingController locationController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  _buildLocationView(){
    return Container(
//      padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px3),
      padding: EdgeInsets.only(left: a.px16, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('开户行所在地', style: TextStyle(fontSize: a.px16),),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: locationController,
              cursorColor: Colors.black12,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '例：上海分行东方支行',
                labelStyle: TextStyle(fontSize: a.px20),
              ),
              autofocus: false,
            ),
          ),
          SizedBox(width: a.px16),
        ],
      ),
    );
  }

  _buildCardView(){
    return Container(
      padding: EdgeInsets.only(left: a.px16, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('银行卡号', style: TextStyle(fontSize: a.px16),),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: cardController,
              textAlign: TextAlign.end,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入银行卡号',
                labelStyle: TextStyle(fontSize: a.px20),
              ),
              autofocus: false,
            ),
          ),
          SizedBox(width: a.px16),
        ],
      ),
    );
  }

  _buildPhoneView(){
    return Container(
      padding: EdgeInsets.only(left: a.px16, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('手机号码', style: TextStyle(fontSize: a.px16),),
          SizedBox(width: a.px30),
          Expanded(
            child: TextField(
              controller: phoneController,
              textAlign: TextAlign.end,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入以后预留的手机号',
                labelStyle: TextStyle(fontSize: a.px20),
              ),
              autofocus: false,
            ),
          ),
          SizedBox(width: a.px16),
        ],
      ),
    );
  }

  _buildOKButton() {
    return Container(
      width: a.screenWidth,
      height: a.px50,
      child: RaisedButton(
        child: Text(
          '确认绑定',
          style: TextStyle(color: Colors.white, fontSize: a.px22),
        ),
        onPressed: _onPressedOK,
        color: Colors.black,
      ),
    );
  }

  _onPressedBank() async{
    var dataList = [
      {'url': 'http://www.cmbchina.com/cmb.ico', 'name': '招商银行'},
      {'url': 'http://www.cmbchina.com/cmb.ico', 'name': '中国银行'},
    ];
    var select = await Utils.navigateTo(BankSelectPage(bank, dataList));
    if(select != null)
      bank = select;
  }
  _onPressedProvince() async{
    MapEntry<String, String> data = await Utils.navigateTo(LocationSelectPage('开户行所在省', provinceData.entries.toList()));
    if(data != null){
      if(selectProvinceData?.value != data.value){
        selectProvinceData = data;
        city = null;
      }
    }
  }
  _onPressedCity() async{
    if(selectProvinceData == null){
      alert('请先选择开户行省份');
      return;
    }
    Map<String, dynamic> cityMapData = citiesData[selectProvinceData.key];

    List<MapEntry<String, dynamic>> cityDataList = cityMapData.entries.toList();
    if(cityDataList.length == 1){
      cityDataList[0].value['name'] = selectProvinceData.value;
    }
    var cityData = await Utils.navigateTo(LocationSelectPage('开户行所在区', cityDataList));
    if(cityData != null){
      city = cityData.value['name'];
    }
  }

  _onPressedOK() async{
    if( bank == null ||
        selectProvinceData == null ||
        city == null ||
        cardController.text.length == 0 ||
        phoneController.text.length == 0
    ){
      alert('请完善银行卡信息');
      return;
    }

    if(!phoneController.approved())
      return;

    print('aproved');
    var result = await UserRequest.bindBankCard(bank, selectProvinceData.value, city, locationController.text, cardController.text, phoneController.text);
    if(result.success){
      await alert('绑定银行卡成功');
      Utils.navigatePop(true);
    }
  }
}
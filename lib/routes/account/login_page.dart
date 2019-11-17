import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'login_input_view.dart';
import 'register_input_view.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/model/account_data.dart';

class LoginPage extends StatelessWidget{
  final isRegister;
  LoginPage(this.isRegister);
  @override
  Widget build(BuildContext context) {
    bool noBack = AccountData.getInstance().token != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('登录注册'),
        leading: noBack ? null : Text(''),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: a.px15),
              alignment: Alignment.center,
              color: Colors.white,
              child: Image.asset(CustomIcons.iconText, width: a.px(80),)
          ),
          _InputView(isRegister),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

class _InputView extends StatefulWidget {
  final isRegister;
  _InputView(this.isRegister);
  @override
  __InputViewState createState() => __InputViewState(isRegister ? 1 : 0);
}

class __InputViewState extends State<_InputView>
with SingleTickerProviderStateMixin{
  __InputViewState(index): _currentIndex = index;

  int _currentIndex = 0;
  final _titles = ['登录', '注册'];
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: _titles.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if(_currentIndex != _tabController.index){
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    _tabController.index = _currentIndex;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child:Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _tabBar(),
              _tabBarView(),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      tabs: _titles.map((title) {
        return Text(title);
      }).toList(),
      controller: _tabController,
      indicatorColor: CustomColors.red,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: false,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      indicatorWeight: a.px(3.0),
      labelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5), fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: a.px17, height: a.px(1.5)),
    );
  }

  Widget _tabBarView() {
    return Expanded(
      child:Container(
        color: CustomColors.background1,
        child: _currentIndex == 0 ? LoginInputView() : RegisterInputView(),
      ),
    );
  }
}

Widget buildTextFiled(controller, keyboardType, labelText, obscureText, icon) {
  return ListTile(
    leading: icon,
    title: TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.black12,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: labelText,
        labelStyle: TextStyle(fontSize: a.px20),
      ),
      obscureText: obscureText,
      enableInteractiveSelection: false,
    ),
    dense: true,
  );
}

Widget buildCaptchaTextFiled(controller, onPressedGetCaptcha) {
  return ListTile(
    leading: Icon(Icons.perm_phone_msg),
    title: TextField(
      controller: controller,
      cursorColor: Colors.black12,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '手机验证码',
        labelStyle: TextStyle(fontSize: a.px20),
      ),
      enableInteractiveSelection: false,
    ),
    trailing: PhoneCaptchaButton(onPressedGetCaptcha),
    dense: true,
    contentPadding: EdgeInsets.only(left: a.px16),
  );
}
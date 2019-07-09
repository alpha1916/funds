import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/user_request.dart';

import 'package:funds/routes/my/settings_page.dart';
import 'package:funds/routes/contract/contract_apply.dart';
import 'package:funds/network/contract_request.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('任务中心'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildSignView(),
            SizedBox(height: a.px12,),
            _buildRookieTask(),
            SizedBox(height: a.px12,),
//            _buildOtherTask(),
//            SizedBox(height: a.px12,),
          ],
        ),
      ),
    );
  }

  bool _isSignedToday = false;
  int _signedDays = 0;
  List<TaskData> _taskDataList = [];

  @override
  initState(){
    super.initState();
    _getData();
  }

  _getData() async{
    _getTaskData();
    if(AccountData.getInstance().isLogin()){
      var result = await UserRequest.getSignData();
      if(result.success){
        SignData data = result.data;
        setState(() {
          _signedDays = data.signedDays;
          _isSignedToday = data.isSignedToday;
        });
        return;
      }
    }
  }

  _getTaskData() async {
    var result = await UserRequest.getTaskData();
    if(result.success){
      setState(() {
        _taskDataList = result.data;
      });
      return;
    }
  }

  _buildSignView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px20),
          _buildSignButton(),
          SizedBox(height: a.px12),
          Text('(每日签到领积分)', style: TextStyle(fontSize: a.px16, color: Colors.black54),),
          _buildSignDaysView(),
          _buildSignDaysExplainView(),
          SizedBox(height: a.px24),
        ],
      ),
    );
  }

  _buildSignButton() {
    String text = _isSignedToday ? '今日已签' : '签到';
    Color backgroundColor = _isSignedToday ? Colors.grey : CustomColors.red;
    return InkWell(
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: a.px44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(CustomIcons.sign, width: a.px32),
            Text(text, style: TextStyle(fontSize: a.px16, color: Colors.white),),
          ],
        ),
      ),
      onTap: _onPressedSign,
    );
  }

  _buildCheckIcon(backgroundColor, radius, checkIconSize){
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: Image.asset(CustomIcons.signChecked, width: checkIconSize),
    );
  }

  _buildSignDaysView(){
    List<Widget> children = [];
    for(int i = 1; i <= 7; ++i){
      Color checkedColor = i <= _signedDays ? CustomColors.red : CustomColors.background1;
      children.add(_buildCheckIcon(checkedColor, a.px16, a.px22));

      if(i < 7){
        children.add(
          Container(
            color: checkedColor,
            width: a.px10,
            height: a.px3,
          )
        );

        children.add(
            Container(
              color: i <= (_signedDays - 1) ? CustomColors.red : CustomColors.background1,
              width: a.px10,
              height: a.px3,
            )
        );
      }
    }

    return Container(
      padding: EdgeInsets.only(top: a.px20, bottom: a.px10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  final List<int> bonusList = [0, 30, 50, 50, 80, 120, 150, 150];
  _buildSignDaysExplainView(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(7, (i){
          int day = i + 1;
          return Container(
            width: a.px(52),
            child: Column(
              children: <Widget>[
                Text('$day天'),
                Text('+${bonusList[day]}'),
              ],
            ),
          );
        }),
      ),
    );
  }

  _buildTaskTitle(title){
    return Container(
      padding: EdgeInsets.symmetric(vertical: a.px16, horizontal: a.px16),
      child: Text(title, style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
    );
  }

  _buildTaskItem(TaskData data){
    Color doneColor = data.done ? Colors.green : CustomColors.background1;
    Widget tips;
    if(data.tips == '')
      tips = Container();
    else{
      tips = Text('(${data.tips})', style: TextStyle(fontSize: a.px13, color: Colors.grey),);
    }
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px3),
        child: Row(
          children: <Widget>[
            _buildCheckIcon(doneColor, a.px10, a.px14),
            SizedBox(width: a.px10,),
            Text(data.title, style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
            tips,
            Utils.expanded(),
            Text(data.strReward, style: TextStyle(fontSize: a.px16, color: CustomColors.red),),
            SizedBox(width: a.px10,),
            Image.asset(data.rewardType == 2 ? CustomIcons.integral : CustomIcons.coupon, width: a.px16,),
            SizedBox(width: a.px10,),
            data.done ? Container() : Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: () {
        if(data.done)
          return;

        _gotoDoTask(data.id);
      },
    );
  }

  _buildTaskItemSplitLine() {
    return Container(
      padding: EdgeInsets.only(left: a.px16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: a.px9,),
          Container(color: CustomColors.background1, width: a.px2, height: a.px20),
          SizedBox(width: a.px20,),
          Expanded(child: Container(height: a.px(0.5), color: Colors.black12)),
        ],
      ),
    );
  }

  _buildTaskListView(dataList){
    List<Widget> children = [];
    for (var i = 0; i < dataList.length; ++i) {
      TaskData data = dataList[i];
      children.add(_buildTaskItem(data));
      if(i < (dataList.length - 1))
        children.add(_buildTaskItemSplitLine());
    }

    return Column(
      children: children
    );
  }

  _buildRookieTask() {
    if(_taskDataList == null || _taskDataList.length == 0)
      return Container();
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTaskTitle('新手任务'),
          Divider(height: a.px1, indent: a.px16),
          SizedBox(height: a.px10),
          _buildTaskListView(_taskDataList),
          SizedBox(height: a.px10),
        ],
      ),
    );
  }

//  _buildOtherTask() {
//    return Container(
//      color: Colors.white,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          _buildTaskTitle('其他任务'),
//          Divider(height: a.px1, indent: a.px16),
//          SizedBox(height: a.px10),
//          _buildTaskItem('首次上传头像', '+300积分'),
//          _buildTaskItemSplitLine(),
//          _buildTaskItem('完成新手问答', '+500积分'),
//          SizedBox(height: a.px10),
//        ],
//      ),
//    );
//  }

  _onPressedSign() async {
    if(_isSignedToday)
      return;

    var result = await UserRequest.sign();
    if(result.success){
      setState(() {
        _isSignedToday = true;
        _signedDays += 1;
        UserRequest.getUserInfo();
      });
    }
  }

  _gotoDoTask(int taskId) async{
    print(taskId);
    switch(taskId){
      case TaskId.register:
        await Utils.navigateToLoginPage(true);
        break;

      case TaskId.certification:
        await Utils.navigateTo(SettingsPage());
        break;

      case TaskId.bindCard:
        await Utils.navigateTo(SettingsPage());
        break;

      case TaskId.applyContract:
        ResultData result = await ContractRequest.getConfigs();
        if(result.success){
          await Utils.navigateTo(ContractApplyPage(result.data));
        }
        break;
    }

    _getTaskData();
  }
}

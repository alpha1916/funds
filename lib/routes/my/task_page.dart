import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';

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
            _buildOtherTask(),
            SizedBox(height: a.px12,),
          ],
        ),
      ),
    );
  }

  bool signed = false;
  int signedDays = 0;
  _buildSignView() {
//    signed = true;
//    signedDays = 5;
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
    String text = signed ? '今日已签' : '签到';
    Color backgroundColor = signed ? Colors.grey : CustomColors.red;
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
      Color checkedColor = i <= signedDays ? CustomColors.red : CustomColors.background1;
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
              color: i <= (signedDays - 1) ? CustomColors.red : CustomColors.background1,
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

  _buildTaskItem(title, award, [awardType = 0, done = false, onPressed]){
    Color doneColor = done ? Colors.green : CustomColors.background1;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px3),
      child: Row(
        children: <Widget>[
          _buildCheckIcon(doneColor, a.px10, a.px14),
          SizedBox(width: a.px10,),
          Text(title, style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
          Utils.expanded(),
          Text(award, style: TextStyle(fontSize: a.px16, color: CustomColors.red),),
          SizedBox(width: a.px10,),
          Image.asset(awardType == 0 ? CustomIcons.integral : CustomIcons.coupon, width: a.px16,),
          SizedBox(width: a.px10,),
          done ? Container() : Utils.buildForwardIcon(),
        ],
      ),
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

  _buildRookieTask() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTaskTitle('新手任务'),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
          SizedBox(height: a.px10),
          _buildTaskItem('完成注册', '+200优惠券礼包', 1, true),
          _buildTaskItemSplitLine(),
          _buildTaskItem('实名', '+800积分'),
          _buildTaskItemSplitLine(),
          _buildTaskItem('绑卡', '+800积分'),
          _buildTaskItemSplitLine(),
          _buildTaskItem('首次操盘', '+1000积分'),
          SizedBox(height: a.px10),
        ],
      ),
    );
  }

  _buildOtherTask() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTaskTitle('其他任务'),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
          SizedBox(height: a.px10),
          _buildTaskItem('首次上传头像', '+300积分'),
          _buildTaskItemSplitLine(),
          _buildTaskItem('完成新手问答', '+500积分'),
          SizedBox(height: a.px10),
        ],
      ),
    );
  }

  _onPressedSign() {
    if(signed)
      return;

    setState(() {
      signed = true;
      signedDays += 1;
    });
  }
}

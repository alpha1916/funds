import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../common/constants.dart';

class TakeTrialPage extends StatefulWidget {
  @override
  _TakeTrialPageState createState() => _TakeTrialPageState();
}

class _TakeTrialPageState extends State<TakeTrialPage> {
  var _dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataList = [
      {'type': 0, 'ongoing' : true, 'title': '免息体验', 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'type': 1, 'ongoing' : false, 'title': '免息体验', 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
//        color: Colors.blue,
        child: Column(
          children: <Widget>[
            _SelectView(),
            _TipsView(),
          ],
        ),
      ),
    );
  }
}

class _TrialItem extends StatelessWidget {
  bool selected;
  bool done;
  int money;
  String periodTips;
  String title;

  Widget _textView() {
    final Color tipsColor = selected ? CustomColors.red : Colors.grey;
    final double topMargin = 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        _getTypeIcon(done),
        Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 45),
                child: Text('$money元', style: TextStyle(color: CustomColors.red, fontSize: 26, fontWeight: FontWeight.w500)),
              ),

              Container(
                margin: EdgeInsets.only(top: topMargin),
                child: Text('操盘体验资金', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
              ),

              Container(
                margin: EdgeInsets.only(top: topMargin),
                child: Text(periodTips, style: TextStyle(color: tipsColor, fontSize: 14)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _decoration() {
    BoxDecoration decoration;
    if(selected)
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Color(0xFFFF0000), width: 1), // 边色与边宽度
      );
    else
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      );

    return decoration;
  }

  @override
  Widget build(BuildContext context) {
    final double size = 160;
    final double traySize = 100;
    final String trayIconPath = selected ? CustomIcons.trialTypeTray1 : CustomIcons.trialTypeTray0;

    List<Widget> stackChildren = [
      Positioned(
        left:0,
        top: 0,
        child: Image.asset(trayIconPath, width: traySize),
      ),
      Positioned(
        left:6,
        top: 4,
        child:Text(title, style: TextStyle(fontSize: 14.0, color: Colors.white),),
      ),
      _textView(),
    ];
    if(done)
      stackChildren.add(Positioned(
        bottom: 0,
        right: 0,
        child: Image.asset(CustomIcons.trialDone, width: 50,),
      ));

    return Container(
      decoration: _decoration(),
      width: size,
      height: size,
      child: Stack(
        children: stackChildren,
      ),
    );
  }
  
  _TrialItem(this.selected, this.done, this.title, this.money, this.periodTips);
}


class _SelectView extends StatefulWidget {
  @override
  __SelectViewState createState() => __SelectViewState();
}

class __SelectViewState extends State<_SelectView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _TrialItem(false, true, '免费体验', 2100, '2个交易日'),
            _TrialItem(true, false, '免息体验', 6100, '一个月'),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 40, bottom: 60),
          width: 180,
          height: 48,
          child: RaisedButton(
            child: const Text('立即体验', style: TextStyle(color: Colors.white, fontSize: 16),),
            onPressed: _onStartTrial,
            color: CustomColors.red,
            shape: StadiumBorder(),
          ),
        ),

      ],
    );
  }

  _onStartTrial() {
    print('start trial');
  }
}

class _TipsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('提示界面'),
    );
  }
}


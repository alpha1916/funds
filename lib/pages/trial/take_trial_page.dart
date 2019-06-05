import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/common/constants.dart';

class TakeTrialPage extends StatefulWidget {
  @override
  _TakeTrialPageState createState() => _TakeTrialPageState();
}

class _TakeTrialPageState extends State<TakeTrialPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: a.px10),
          child: Column(
            children: <Widget>[
              _SelectView(),
              _TipsView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrialItem extends StatelessWidget {
  final int idx;
  final bool selected;
  final bool done;
  final String money;
  final String periodTips;
  final String title;
  final void Function(int idx) onPressed;
  _TrialItem(
      this.idx,
      this.selected,
      this.done,
      this.title,
      this.money,
      this.periodTips,
      {
        this.onPressed,
      });

  Widget _textView() {
    final Color tipsColor = selected ? CustomColors.red : Colors.grey;
    final double topMargin = a.px10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        _getTypeIcon(done),
        Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: a.px45),
                child: Text('$money元',
                    style: TextStyle(
                        color: CustomColors.red,
                        fontSize: a.px26,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                margin: EdgeInsets.only(top: topMargin),
                child: Text(
                  '操盘体验资金',
                  style: TextStyle(fontSize: a.px18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: topMargin),
                child: Text(periodTips,
                    style: TextStyle(color: tipsColor, fontSize: a.px14)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _decoration() {
    BoxDecoration decoration;
    if (selected)
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(a.px10)),
        border: Border.all(color: Color(0xFFFF0000), width: a.px1), // 边色与边宽度
      );
    else
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(a.px5)),
      );

    return decoration;
  }

  @override
  Widget build(BuildContext context) {
    final double size = a.px(160);
    final double traySize = a.px(100);
    final String trayIconPath =
        selected ? CustomIcons.trialTypeTray1 : CustomIcons.trialTypeTray0;

    List<Widget> stackChildren = [
      Positioned(
        left: 0,
        top: 0,
        child: Image.asset(trayIconPath, width: traySize),
      ),
      Positioned(
        left: a.px6,
        top: a.px4,
        child: Text(
          title,
          style: TextStyle(fontSize: a.px14, color: Colors.white),
        ),
      ),
      _textView(),
    ];
    if (done)
      stackChildren.add(Positioned(
        bottom: 0,
        right: 0,
        child: Image.asset(
          CustomIcons.trialDone,
          width: a.px50,
        ),
      ));

    return GestureDetector(
      child: Container(
        decoration: _decoration(),
        width: size,
        height: size,
        child: Stack(
          children: stackChildren,
        ),
      ),
      onTap: () {
        onPressed(idx);
      },
    );
  }
}

class _SelectView extends StatefulWidget {
  @override
  __SelectViewState createState() => __SelectViewState();
}

class __SelectViewState extends State<_SelectView> {
  int _selectedIdx = 0;
  List<Map<String, dynamic>>_dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataList = [
      {'done': false, 'title': '免费体验', 'money': '2100', 'period': '2个交易日'},
      {'done': false, 'title': '免息体验', 'money': '6100', 'period': '一个月'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _dataList.map((data){
            final int idx = _dataList.indexOf(data);
            final bool selected = _selectedIdx == idx;
            final bool done = data['done'];
            final String title = data['title'];
            final String money = data['money'];
            final String period = data['period'];
            return _TrialItem(
                idx,
                selected,
                done,
                title,
                money,
                period,
                onPressed: _onItemSelected,
            );
          }).toList(),
        ),
        Container(
          margin: EdgeInsets.only(top: a.px40, bottom: a.px(60)),
          width: a.px(180),
          height: a.px48,
          child: RaisedButton(
            child: Text(
              '立即体验',
              style: TextStyle(color: Colors.white, fontSize: a.px16),
            ),
            onPressed: _onStartTrial,
            color: CustomColors.red,
            shape: StadiumBorder(),
          ),
        ),
      ],
    );
  }

  _onItemSelected(int idx) {
    if(_selectedIdx != idx){
      setState(() {
        _selectedIdx = idx;
      });
    }
  }

  _onStartTrial() {
    print('start trial');
  }
}

class _TipsView extends StatelessWidget {
  static final String p1 = '1、全民来配资，xx为你准备了如下体验合约：';
  static final String p2 = '免费体验和免息体验可以同时申请，且只能体验一次';
  static final String p3 = '2、 体验合约在合约结算后，盈亏部分+杠杆本金将返还至你的现金余额中(若免费体验合约产生亏损，杠杆本金全额返还)，可进行正常提现操作；';
  static final String p4 = '3、 请于合约到期日14:00前确保合约空仓，否则系统会在14:00后执行自动卖出指令，不保证卖出价格；';
  static final String p5 = '4、 体验合约不支持放大、缩小合约功能，如需体验xx亮点可直接前往股票交易申请普通合约。';
  static final String p6 = 'xx对此活动拥有最终解释权';

  Widget _tipsContent(String text) {
    final double px18 = a.px18;
    TextStyle tipsContentStyle = TextStyle(fontSize: a.px14, color: Colors.black54);
    return Padding(
      padding: EdgeInsets.only(left: px18, right: px18, bottom: px18),
      child: Text(text, style: tipsContentStyle),
    );
  }

  Widget _gridTitle(text) {
    return Container(
      height: a.px30,
      color: Colors.white,
      child:Center(
        child:Text(text,
          style: TextStyle(
            fontSize: a.px14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _gridItemView(String text, Color color) {
    return Container(
      height : a.px30,
      margin: EdgeInsets.all(a.px(0.5)),
      color: Colors.white,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: a.px13,
            color: color,
          ),
        )
      ),

    );
  }

  TableRow _buildRow(textList) {
    return TableRow(
      children: <Widget> [
        _gridItemView(textList[0], Colors.black54),
        _gridItemView(textList[1], Colors.black),
        _gridItemView(textList[2], CustomColors.red),
        _gridItemView(textList[3], Colors.black),
        _gridItemView(textList[4], CustomColors.red),
      ],
    );
  }

  Widget _gridView() {
    return Container(
      child: Column(
        children: <Widget>[
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow> [
              TableRow(
                  children: <Widget> [
                    _gridTitle(''),
                    _gridTitle('杠杆本金'),
                    _gridTitle('赠送资金'),
                    _gridTitle('交易期限'),
                    _gridTitle('风险承担'),
                  ]
              ),
              _buildRow(['免费体验', '100', '2000', '2个交易日', '亏损全赔付']),
              _buildRow(['免息体验', '1000', '5000', '1个月', '亏损你承担']),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: a.px18, right: a.px5),
                  height: a.px2,
                  color: Colors.black12,
                ),
              ),
              Text(
                '* 活动规则 *',
                style: TextStyle(fontSize: a.px16),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: a.px5, right: a.px18),
                  height: a.px2,
                  color: Colors.black12,
                ),
              ),
            ],
          ),
          SizedBox(height: a.px15),
          _tipsContent(p1),
          _gridView(),
          SizedBox(height: a.px15),
          _tipsContent(p2),
          _tipsContent(p3),
          _tipsContent(p4),
          _tipsContent(p5),
          _tipsContent(p6),
        ],
      ),
    );
  }
}

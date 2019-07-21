import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/routes/contract/contract_apply_detail.dart';

class TakeTrialPage extends StatefulWidget {
  @override
  _TakeTrialPageState createState() => _TakeTrialPageState();
}

class _TakeTrialPageState extends State<TakeTrialPage> {
  List<ExperienceInfoData>_dataList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async{
    await Future.delayed(Duration(milliseconds: 10));
    await UserRequest.getUserInfo();
    ResultData result = await ExperienceRequest.getInfoList();
    if(!mounted)
      return;

    if(result.success){
      setState(() {
        _dataList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _dataList == null ? [] : [_SelectView(_dataList), _TipsView(_dataList)];
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: a.px10),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}

class _TrialItem extends StatelessWidget {
  final int idx;
  bool done;
  int money;
  String periodTips;
  String title;

//  final data;
  final bool selected;
  final void Function(int idx) onPressed;
  _TrialItem(
      ExperienceInfoData data,
      this.idx,
      this.done,
      this.selected,
      {
        this.onPressed,
      }){
    money = data.loanAmount + data.capital;
    title = data.title;
    done = AccountData.getInstance().isExperienceDone(data.id);
    periodTips = data.timeLimit;
  }

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

    return InkWell(
      child: Container(
        decoration: _decoration(),
        width: size,
        height: size,
        child: Stack(
          children: stackChildren,
        ),
      ),
      onTap: () {
        if(!done)
          onPressed(idx);
      },
    );
  }
}

class _SelectView extends StatefulWidget {
  final List<ExperienceInfoData> dataList;
  _SelectView(this.dataList);
  @override
  _SelectViewState createState() => _SelectViewState();
}

class _SelectViewState extends State<_SelectView> {
  int _selectedIdx;
  List<ExperienceInfoData> _dataList;
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataList = widget.dataList;
    for(int i = 0; i < _dataList.length; ++i){
      ExperienceInfoData data = _dataList[i];
      if(!AccountData.getInstance().isExperienceDone(data.id)){
        _selectedIdx = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _dataList.map<Widget>((ExperienceInfoData data){
            final int idx = _dataList.indexOf(data);
            final bool done = AccountData.getInstance().isExperienceDone(data.id);
            final bool selected = _selectedIdx == idx;
            return _TrialItem(data, idx, done, selected, onPressed: _onItemSelected);
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

  _onStartTrial() async {
    print('start experience');
    if(_selectedIdx == null){
      alert('请选择要体验的项目');
      return;
    }
    ExperienceInfoData selectedData = _dataList[_selectedIdx];

    ResultData result = await ExperienceRequest.preApplyContract(selectedData.id);

    if(mounted && result.success){
      ContractApplyDetailData data = result.data;
      data.experienceId = selectedData.id;
      data.contractType = ContractApplyDetailData.experienceType;
      data.title = selectedData.title;
      data.capital = selectedData.capital;
      data.total = selectedData.capital + selectedData.loanAmount;
      data.period = '${selectedData.timeLimit}，到期不可续约';

      await Utils.navigateTo(ContractApplyDetailPage(data));
      setState(() {
      });
    }
  }
}

class _TipsView extends StatelessWidget {
  final List<ExperienceInfoData> _dataList;
  _TipsView(this._dataList);
  static final String p1 = '1、全民来配资，${Global.appName}你准备了如下体验合约：';
  static final p2 = [
    '免费体验和免息体验可以同时申请，且只能体验一次',
    '2、 体验合约在合约结算后，盈亏部分+杠杆本金将返还至你的现金余额中(若免费体验合约产生亏损，杠杆本金全额返还)，可进行正常提现操作；',
    '3、 请于合约到期日14:00前确保合约空仓，否则系统会在14:00后执行自动卖出指令，不保证卖出价格；',
    '4、 体验合约不支持放大、缩小合约功能，如需体验${Global.appName}亮点可直接前往股票交易申请普通合约。',
    '${Global.appName}对此活动拥有最终解释权'
  ];

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

  TableRow _buildRow(ExperienceInfoData data) {
    return TableRow(
      children: <Widget> [
        _gridItemView(data.title, Colors.black54),
        _gridItemView(data.capital.toString(), Colors.black),
        _gridItemView(data.loanAmount.toString(), CustomColors.red),
        _gridItemView(data.timeLimit, Colors.black),
        _gridItemView(data.riskTips, CustomColors.red),
      ],
    );
  }

  Widget _gridView() {
    List<TableRow> tableRowList = [
      TableRow(
        children: <Widget> [
          _gridTitle(''),
          _gridTitle('杠杆本金'),
          _gridTitle('赠送资金'),
          _gridTitle('交易期限'),
          _gridTitle('风险承担'),
        ]
      )
    ];

    for(int i = 0; i < _dataList.length; ++i){
      ExperienceInfoData data = _dataList[i];
      tableRowList.add(_buildRow(data));
    }


    return Container(
      child: Column(
        children: <Widget>[
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: tableRowList,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget line = Expanded(
      child: Container(
        margin: EdgeInsets.only(left: a.px18, right: a.px5),
        height: a.px2,
        color: Colors.black12,
      ),
    );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              line,
              Text('* 活动规则 *', style: TextStyle(fontSize: a.px16)),
              line,
            ],
          ),
          SizedBox(height: a.px15),
          _tipsContent(p1),
          _gridView(),
          SizedBox(height: a.px15),
          _tipsContent(p2.join('\n\n')),
        ],
      ),
    );
  }
}

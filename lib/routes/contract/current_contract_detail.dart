import 'package:flutter/material.dart';
import 'dart:math';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/custom_dialog.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/trade/stock_trade_main.dart';
import 'contract_add_capital_page.dart';
import 'contract_apply_delay_page.dart';
import 'limit_stock_list_page.dart';
import 'current_contract_withdraw_page.dart';
import 'package:funds/pages/trade/contract_flow_page.dart';

var realWidth;
var ctx;

class CurrentContractDetail extends StatefulWidget {
  final ContractData data;
  CurrentContractDetail(this.data);
  @override
  _CurrentContractDetailState createState() => _CurrentContractDetailState();
}

class _CurrentContractDetailState extends State<CurrentContractDetail> {
  ContractData data;

  _refresh() async {
    ResultData result = await ContractRequest.getContractDetail(data.contractNumber);
    if(result.success && mounted){
      setState(() {
        data = result.data;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    realWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(data?.title ?? '当前合约详情'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                size: a.px32, color: Colors.black87),
            onPressed: onPressedRefresh,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildDelaySellTips(),
                  //资产栏
                  _buildFundsView(),
                  _buildSplitLine(),
                  //信息栏
                  _buildInfoView(),
                  _buildSplitLine(),
                  //图标栏
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    _buildUnderlineTextButton('今日限买股', _onPressedLimited),
                  ]),
                  SizedBox(
                    height: a.px10,
                  ),
                  _buildMeterView(realWidth),
                  _buildSplitLine(),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: a.px42),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '警戒线：${data?.cordon ?? 0}',
                          style: TextStyle(fontSize: a.px16),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          '止损线：${data?.cut ?? 0}',
                          style: TextStyle(fontSize: a.px16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Table(
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  _buildMoreButton(),
                  _buildBottomButton(
                      title: '提取现金', onPressed: _onPressedWithdraw),
                  _buildBottomButton(
                    title: '委托交易',
                    titleColor: Colors.white,
                    bgColor: Colors.black,
                    onPressed: _onPressedTrade,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildInfoView() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: a.px18,
          ),
          Text(
            '合约信息',
            style: TextStyle(fontSize: a.px16),
          ),
          Text(
            '(${data.contractNumber})',
            style: TextStyle(fontSize: a.px12),
          ),
          Expanded(
            child: Container(),
          ),
          _buildUnderlineTextButton('查看合约流水', _onPressedFlow),
        ]),
        Table(
          children: <TableRow>[
            TableRow(
              children: [
                _buildInfoItem('杠杆本金', data.capital.toStringAsFixed(2)),
                _buildInfoItem('借款金额', data.loan.toStringAsFixed(2)),
              ],
            ),
            TableRow(
              children: [
                _buildInfoItem('合约金额', data.contractMoney.toStringAsFixed(2)),
                _buildInfoItem('操盘金额', data.operateMoney.toStringAsFixed(2)),
              ],
            ),
            TableRow(
              children: [
                _buildInfoItem('管理费用', '${data.cost.toStringAsFixed(2)}/月'),
                _buildInfoItem('使用天数', '${data.days}个交易日'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _buildInfoItem(title, value) {
    return Container(
      padding: EdgeInsets.only(
        left: a.px18,
        right: a.px18,
        top: a.px5,
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: a.px16),
          ),
          SizedBox(
            width: a.px8,
          ),
          Text(
            value,
            style: TextStyle(fontSize: a.px14),
          ),
        ],
      ),
    );
  }

  _buildUnderlineTextButton(title, onPressed) {
    return Container(
        height: a.px20,
        child: FlatButton(
          child: Text(
            title,
            style: TextStyle(
              fontSize: a.px16,
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed: onPressed,
        ));
  }

  _onPressedFlow() async{
    var result = await ContractRequest.getFlow(data.contractNumber);
    if(result.success)
      Utils.navigateTo(ContractFlowPage(result.data));
  }

  _onPressedLimited() async{
    print('press limit');
    var result = await ContractRequest.getLimitStockList();
    if(result.success){
      Utils.navigateTo(LimitStockListPage(result.data));
    }
  }

  _onPressedWithdraw() async{
    print('press withdraw');
    var done = await Utils.navigateTo(CurrentContractWithdrawPage(data.contractNumber, data.cash));
    if(done == true){
      await UserRequest.getUserInfo();
      _refresh();
    }
  }

  _onPressedTrade() {
    print('press trade');
    Utils.navigateTo(StockTradeMainPage(data.contractNumber, data.title));
  }

  _buildBottomButton({
    title,
    titleColor = Colors.black,
    bgColor = Colors.white,
    onPressed,
    icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: FlatButton(
        child: Text(
          title,
          style: TextStyle(fontSize: a.px18, color: titleColor),
        ),
        onPressed: onPressed,
      ),
    );
  }

  _buildMoreButton() {
    final buttonView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: FlatButton(
        onPressed: null,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.menu,
              color: Colors.black,
              size: a.px20,
            ),
            Text(
              '更多操作',
              style: TextStyle(fontSize: a.px18, color: Colors.black),
            ),
          ],
        ),
      )
    );

    buildMenuItem(title, value) {
      return PopupMenuItem<int>(
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
        value: value,
      );
    }

    List<PopupMenuItem<int>> menuItems = [
      buildMenuItem('追加本金', ContractOperate.addMoney),
      buildMenuItem('申请结算', ContractOperate.applySettlement),
      buildMenuItem('申请停牌回收', ContractOperate.applySuspendedCycle)
    ];

    if(data.canDelay)
      menuItems.insert(2, buildMenuItem('延期卖出', ContractOperate.delaySell));

    return PopupMenuButton<int>(
      child: buttonView,
      itemBuilder: (builder) => menuItems,
      onSelected: (value) async{
        print(value);
        switch(value){
          case ContractOperate.addMoney:
            double minAdd = (data.operateMoney * 0.01 * 100).round() / 100;
            var success = await Utils.navigateTo(ContractAddCapitalPage(data.contractNumber, minAdd));
            if(success == true)
              _refresh();
            break;

          case ContractOperate.applySettlement:
            int select = await CustomDialog.show3('提示', '提前终止不退还已收管理费，确认结算当前合约？', '取消', '确定');
            if(select == 2){
              ResultData result = await ContractRequest.applySettlement(data.contractNumber);
              if(result.success){
                alert('申请结算成功');
                Utils.navigatePop();
              }
            }
            break;

          case ContractOperate.delaySell:
            _onPressedApplyDelaySell();
            break;

          case ContractOperate.applySuspendedCycle:
            break;

        }
      },
    );
  }

  _buildSplitLine() {
    return Container(
      height: a.px1,
      margin: EdgeInsets.symmetric(vertical: a.px10),
      color: Colors.black26,
    );
  }

  _buildFundsItem(title, value, valueFontSize,
      [percent, onPressed]) {
    Widget titleText;
    if (onPressed != null) {
      titleText = Row(
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  fontSize: a.px15, color: Colors.black87)),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            child: Icon(
              Icons.help,
              size: a.px24,
            ),
            onTap: onPressed,
          ),
        ],
      );
    } else {
      titleText = Text(title,
          style:
              TextStyle(fontSize: a.px15, color: Colors.black87));
    }
    List<Widget> children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleText,
          SizedBox(height: a.px5),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
                fontSize: valueFontSize,
                color: Utils.getProfitColor(value),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      Expanded(child: Container()),
      SizedBox(width: a.px16),
    ];
    if (onPressed != null)
      children.add(Container(
        height: 30,
        width: 1,
        color: Colors.white30,
      ));

    return Container(
      child: Row(
        children: children,
      ),
    );
  }

  _buildFundsView() {
    return Container(
      margin: EdgeInsets.only(
          left: a.px30, top: a.px20),
      child: Column(
        children: <Widget>[
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  _buildFundsItem('资产总值', data.totalMoney,
                      a.px25),
                  _buildFundsItem(
                    '可提现金',
                    data?.cash ?? 0,
                    a.px25,
                    null,
                    () {
                      alert2('可提现金', '可提现金=非杠杆现金+当前盈亏，盘后可提现', '知道了');
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: a.px8),
          _buildFundsItem(
            '累计盈亏',
            data?.profit ?? 0,
            a.px18,
            null,
            () {
              alert2('累计盈亏', '累计盈亏=当前盈亏+利润提取', '知道了');
            },
          ),
        ],
      ),
    );
  }

  _buildDelaySellTips() {
    if(!data.canDelay || data.leftDays > 1){
      return Container();
    }
    double fontSize = a.px15;
    return Container(
      padding: EdgeInsets.only(left: a.px16),
      color: Color(0xFFFEEEC0),
      child: Row(
        children: <Widget>[
          Icon(Icons.info, size: a.px22, color: CustomColors.red),
          SizedBox(width: a.px6,),
          Text('当前合约于今日到期，', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),),
          FlatButton(
            child: Text(
              '点击申请延期卖出',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: _onPressedApplyDelaySell,
          ),
          Text('>>', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }

  _getRotateAngle() {
    if (data == null) return 0.0;

    //根据图片pi*0.3角度为警戒线到止损线之间的角度差
    double unit = pi * 0.3 / (data.cordon - data.cut);
    double angle = (data.totalMoney - data.cordon) * unit;

    //根据图片，旋转左边最小值为-1.4，右边最大值为1.35
    angle = max(angle, -1.4);
    angle = min(angle, 1.35);

    return angle;
  }

  _buildMeterView(width) {
    return Stack(
      children: <Widget>[
        Image.asset(CustomIcons.meter, width: width),
        Positioned(
          left: width * 0.5,
          bottom: 0,
          child: Transform.rotate(
            angle: _getRotateAngle(),
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              CustomIcons.meterArrow,
              height: width * 0.34,
            ),
          ),
        ),
      ],
    );
  }

  onPressedRefresh() {
    _refresh();
  }

  _onPressedApplyDelaySell() async{
//    CustomDialog.show3('提示', tips, btnTitle1, btnTitle2);
    var result = await Utils.navigateTo(ContractApplyDelayPage());
    if(result == true){
      await alert('延期成功');
      _refresh();
    }
  }
}

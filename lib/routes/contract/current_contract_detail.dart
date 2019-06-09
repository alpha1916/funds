import 'package:flutter/material.dart';
import 'dart:math';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/routes/trade/stock_trade_main.dart';

var realWidth;
var ctx;

class CurrentContractDetail extends StatefulWidget {
  @override
  _CurrentContractDetailState createState() => _CurrentContractDetailState();
}

class _CurrentContractDetailState extends State<CurrentContractDetail> {
  CurrentContractDetailData data;

  _getData() async {
    data = await HttpRequest.getCurrentContractDetail();
    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    realWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
            '(${data?.info ?? ''})',
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
                _buildInfoItem('杠杆本金', data?.capital.toString()),
                _buildInfoItem('借款金额', data?.loan.toString()),
              ],
            ),
            TableRow(
              children: [
                _buildInfoItem('合约金额', data?.contract.toString()),
                _buildInfoItem('操盘金额', data?.stocks.toString()),
              ],
            ),
            TableRow(
              children: [
                _buildInfoItem('管理费用', '${data?.capital}/月'),
                _buildInfoItem('使用天数', '${data?.days ?? 0}个交易日'),
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

  _onPressedFlow() {
    print('press cash flow');
  }

  _onPressedLimited() {
    print('press limit');
  }

  _onPressedWithdraw() {
    print('press withdraw');
  }

  _onPressedTrade() {
    print('press trade');
    Utils.navigateTo(StockTradeMainPage(data.title));
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
        ));

    return PopupMenuButton<int>(
      child: buttonView,
      itemBuilder: (builder) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              child: Text(
                "追加本金",
                textAlign: TextAlign.center,
              ),
              value: 1,
            ),
            const PopupMenuItem<int>(
              child: Text(
                "缩小合约",
                textAlign: TextAlign.center,
              ),
              value: 1,
            ),
            const PopupMenuItem<int>(
              child: Text(
                "放大合约",
                textAlign: TextAlign.center,
              ),
              value: 1,
            ),
            const PopupMenuItem(
              child: Text("申请结算"),
              value: 2,
            ),
            const PopupMenuItem(
              child: Text("停牌转合约"),
              value: 3,
            )
          ],
      onSelected: (item) {},
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
            value.toString(),
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
                  _buildFundsItem('资产总值', data?.total ?? 0,
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

  _getRotateAngle() {
    if (data == null) return 0.0;

    //根据图片pi*0.3角度为警戒线到止损线之间的角度差
    double unit = pi * 0.3 / (data.cordon - data.cut);
    double angle = (data.total - data.cordon) * unit;

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
    _getData();
  }
}

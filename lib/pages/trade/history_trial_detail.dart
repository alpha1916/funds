import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/contract_request.dart';
import 'contract_flow_page.dart';
import 'trade_flow_page.dart';


class HistoryTrialDetail extends StatelessWidget {
  final ContractData data;
  HistoryTrialDetail(this.data);
  final EdgeInsetsGeometry _itemPadding = EdgeInsets.symmetric(vertical: a.px16, horizontal: a.px16);
  final Widget _splitLine = Container(
    color: Colors.white,
    child: Container(
      height: a.px(0.5), color: CustomColors.splitLineColor1, margin: EdgeInsets.only(left: a.px16),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史合约详情'),
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTitleView(),
                _splitLine,
                _buildInfoView(),
                _splitLine,
                _buildCostItem('资产总值', data.totalMoney),
                _splitLine,
                _buildCostItem('累计盈亏', data.profit, Utils.getProfitColor(data.profit)),
                _splitLine,
                _buildSettlementView(),
                _splitLine,
                _buildCostItem('实收管理费', data.realCost),
                SizedBox(height: a.px10,),
                _buildClickableItem('查看合约流水', _onPressFlow),
                _splitLine,
                _buildClickableItem('查看历史交易', _onPressTradeHistory),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTitleView() {
    String strDate = '${data.beginTime} 至 ${data.endTime}';
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(data.title, style: TextStyle(fontSize: a.px16, color: Colors.black)),
          Text(strDate, style: TextStyle(fontSize: a.px13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  _buildInfoView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px16, bottom: a.px6),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Text(
              '合约信息',
              style: TextStyle(fontSize: a.px16),
            ),
            Text(
              '(${data.contractNumber})',
              style: TextStyle(fontSize: a.px14),
            ),
          ]),
          SizedBox(height: a.px10,),
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
            ],
          ),
        ],
      ),
    );
  }

  _buildInfoItem(title, value) {
    return Container(
      margin: EdgeInsets.only(bottom: a.px10),
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
            style: TextStyle(fontSize: a.px16),
          ),
        ],
      ),
    );
  }

  _buildCostItem(String title, double cost, [Color color]){
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
          Text(cost.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _buildSettlementView(){
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('结算退还', style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
          Text('(${data.profitRate}%盈利分配)', style: TextStyle(fontSize: a.px13, color: Colors.black)),
          Expanded(child:Container()),
          Text(data.returnMoney.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500, color: Utils.getProfitColor(data.returnMoney)),
          ),
        ],
      ),
    );
  }

  _buildClickableItem(title , onPressed) {
    return InkWell(
      child: Container(
        padding: _itemPadding,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
            Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _onPressFlow() async{
    print('flow');
    var result = await ContractRequest.getFlow(data.contractNumber);
    if(result.success)
      Utils.navigateTo(ContractFlowPage(result.data));
  }

  _onPressTradeHistory() async{
    print('history');
    ResultData result = await ContractRequest.getTradeFlowList(data.contractNumber);
//    ResultData result = await ContractRequest.getTradeFlowList('00120515000261');
    if(result.success)
      Utils.navigateTo(TradeFlowPage('交易流水', StateType.deal, result.data));
  }
}


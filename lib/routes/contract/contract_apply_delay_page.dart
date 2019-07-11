import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/common/utils.dart';
import 'package:flutter/cupertino.dart';
import 'delay_apply_confirm_dialog.dart';

class ContractApplyDelayPage extends StatefulWidget {
  final List<ContractDelayData> delayDataList;
  final ContractData contractData;
  ContractApplyDelayPage(this.contractData, this.delayDataList);
  @override
  _ContractApplyDelayPageState createState() => _ContractApplyDelayPageState();
}

class _ContractApplyDelayPageState extends State<ContractApplyDelayPage> {
  final EdgeInsetsGeometry _itemPadding = EdgeInsets.symmetric(vertical: a.px16, horizontal: a.px16);
  ContractDelayData _selectData;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _update(0);
  }

  _update(index){
    _selectedIndex = index;
    _selectData = widget.delayDataList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('延期卖出'),
      ),
      body: Column(
        children: <Widget>[
          _buildInfoView(),
          Divider(height: 0, indent: a.px16),
          _buildDaySelectView(),
          Divider(height: 0, indent: a.px16),
          _buildEndDateView(),
          Divider(height: 0, indent: a.px16),
          _buildCostView(),
          _buildTipsView(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  _buildInfoView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: a.px16, top: a.px10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('合约信息', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500)),
              Text(' (${widget.contractData.profitRate}%盈利分配)', style: TextStyle(fontSize: a.px13)),
            ],
          ),
          SizedBox(height: a.px10),
          Divider(height: 0,),
          SizedBox(height: a.px10),
          Table(
            children: <TableRow>[
              TableRow(
                children: [
                  _buildInfoItem('杠杆本金', widget.contractData.capital.toStringAsFixed(2)),
                  _buildInfoItem('借款金额', widget.contractData.loan.toStringAsFixed(2)),
                ],
              ),
              TableRow(
                children: [
                  _buildInfoItem('合约金额', widget.contractData.contractMoney.toStringAsFixed(2)),
                  _buildInfoItem('操盘金额', widget.contractData.operateMoney.toStringAsFixed(2)),
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

  _buildDaySelectView(){
    return InkWell(
      child: Container(
        color: Colors.white,
        padding: _itemPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('延期期限', style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
            Expanded(child: Container()),
            Text('${_selectData.days}个交易日', style: TextStyle(fontSize: a.px16, color: Colors.black, fontWeight: FontWeight.w500)),
            Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: _onPressedSelectDay,
    );
  }

  _buildCostView() {
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('延期费用', style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
          Text('${_selectData.cost}元', style: TextStyle(fontSize: a.px16, color: Colors.black, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  _buildEndDateView(){
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('合约到期', style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
          Text('(延期后)', style: TextStyle(fontSize: a.px13, color: Colors.black)),
          Expanded(child:Container()),
          Text(_selectData.date, style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  _buildTipsView(){
    double fontSize = a.px15;
    return Container(
      padding: EdgeInsets.all(a.px16),
      child: RichText(
        text: TextSpan(
//          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(text: '最长可延期', style: TextStyle(fontSize: fontSize, color: Colors.black)),
            TextSpan(text: widget.delayDataList.length.toString(), style: TextStyle(fontSize: fontSize, color: CustomColors.red)),
            TextSpan(text: '个交易日,管理费一次性收取，延期后合约维持',style: TextStyle(fontSize: fontSize, color: Colors.black)),
            TextSpan(text: '限买状态', style: TextStyle(fontSize: fontSize, color: CustomColors.red)),
            TextSpan(text: '且利益分配不变', style: TextStyle(fontSize: fontSize, color: Colors.black)),
          ],
        ),
      ),
    );
  }
  
  _buildConfirmButton() {
    return Container(
      width: a.px(180),
      height: a.px50,
      child:RaisedButton(
        child: Text('确认', style: TextStyle(color: Colors.white, fontSize: a.px15)),
        onPressed: () async{
          bool confirm = await ContractDelayApplyConfirmDialog.show(_selectData.cost, _selectData.integral);
//          String tips = '共计${_selectData.cost}，可得${_selectData.integral}积分';
//          bool confirm = await Utils.showConfirmOptionsDialog(tips: tips, confirmTitle: '立即申请');
          print(confirm);
          if(confirm){
            ResultData result = await ContractRequest.applyDelay(widget.contractData.contractNumber, _selectData.days);
            if(result.success){
              await alert('延期成功');
              Utils.navigatePop(true);
            }
          }
        },
        color: Colors.black,
        shape: StadiumBorder(),
      ),
    );
  }

  _onPressedSelectDay() async{
    int selectedIndex = 0;

    List<Widget> items = [];
    for(int i = 1; i <= widget.delayDataList.length; ++i){
      items.add(Text(
        '$i个交易日',
        style: TextStyle(
          fontSize: a.px24,
        ),
      ));
    }
    final picker  = CupertinoPicker(
      itemExtent: a.px36,
      onSelectedItemChanged: (index) => selectedIndex = index,
      children: items,
    );

    await showCupertinoModalPopup(
      context: Global.buildContext,
      builder: (cxt){
        return Material(
          child: Container(
            height: a.px(200),
            child: picker,
          )
        );
      }
    );

    if(_selectedIndex != selectedIndex){
      setState(() {
        _update(selectedIndex);
      });
    }
  }
}

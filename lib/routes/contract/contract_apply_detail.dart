import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/custom_dialog.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/model/coupon_data.dart';
import 'package:funds/routes/contract/coupon_select.dart';
import 'package:funds/routes/recharge/recharge_page.dart';
import 'apply_confirm_dialog.dart';
import 'package:funds/routes/webview_page.dart';


class ContractApplyDetailPage extends StatefulWidget {
  final ContractApplyDetailData data;
  ContractApplyDetailPage(this.data);

  @override
  _ContractApplyDetailPageState createState() => _ContractApplyDetailPageState();
}

class _ContractApplyDetailPageState extends State<ContractApplyDetailPage> {
  ContractApplyDetailData data;
  List<CouponData> _coupons;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;

    _getCouponData();
  }

  _getCouponData() async{
    if(data.contractType != ContractApplyDetailData.normalType || data.type == 4)
      return;

    var result = await UserRequest.getMyCouponsData();
    if(result.success){
      setState(() {
        _coupons = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        actions: [
          Utils.buildMyTradeButton(),
        ],
      ),
      body:Container(
        color: CustomColors.background2,
        child: Column(
          children: <Widget>[
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTitleView(),
                  _buildItemList(),
                  _buildAgreeView(),
                ],
              ),
            ),),
            _buildButton(),
          ],
        ),
      ),
    );

  }

  _buildProfitTips() {
    return Container(
      width: a.px(138),
      height: a.px25,
      decoration: BoxDecoration(
        color: CustomColors.red,
        borderRadius: BorderRadius.all(Radius.circular(a.px10)),
      ),
      child: Center(
        child: Text(
          '${data.profit}%盈利分配',
          style: TextStyle(
            fontSize: a.px15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _buildTitleView() {
    return Center(
      child:Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: a.px32, bottom: a.px30),
        color: Color(0xFF201F46),
        child: Column(
          children: <Widget>[
            Text(data.total.toString(), style: TextStyle(fontSize: a.px32, color: Color(0xFFFCC94C)),),
            SizedBox(height: a.px12),
            Text('合约金额 = 申请资金 + 杠杆资金', style: TextStyle(fontSize: a.px15, color: Colors.white),),
            SizedBox(height: a.px12),
            _buildProfitTips(),
          ],
        ),
      )
    );
  }

  Widget _buildItemView(title, content, contentColor, [titleTips, titleIcon = false, onPressed]) {
    List<Widget> list = [];
    //标题
    list.add(Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: a.px18,
          fontWeight: FontWeight.w500,
        )
    ));

    if(titleTips != null) {
      //标题文字提示
      list.add(Container(width: a.px5,));
      list.add(Text(
          '($titleTips)',
          style: TextStyle(
            color: Colors.black54,
            fontSize: a.px12,
          )
      ));
    }else if(titleIcon){
      //标题图标
      list.add(Container(width: a.px5,));
      list.add(Icon(Icons.help, color: Colors.black54,));
    }
    list.add(Expanded(child: Container()));
    list.add(Text(
        content,
        style: TextStyle(
          color: contentColor,
          fontSize: a.px16,
          fontWeight: FontWeight.w500,
        )
    ));

    Widget view = Container(
      color: Colors.white,
      padding: EdgeInsets.all(a.px16),
      child: Row(
        children: list,
      ),
    );

    if(onPressed == null){
      return view;
    }

    return InkWell(
      child: view,
      onTap: onPressed,
    );
  }

  CouponData _selectedCoupon;
  Widget _buildCouponItemView() {
    final px12 = a.px12;
    String content1;
    String content2;
    if(_selectedCoupon != null){
      content1 = '${_selectedCoupon.cost} 元';
      content2 = '优惠券';
    }else{
      content1 = _coupons.length.toString();
      content2 = '张可用';
    }
    List<Widget> list = [];
    //标题
    list.add(Text(
        '抵用券',
        style: TextStyle(
          color: Colors.black87,
          fontSize: a.px18,
          fontWeight: FontWeight.w500,
        )
    ));

    list.add(Expanded(child: Container()));
    list.add(Text(
        content1,
        style: TextStyle(
          color: CustomColors.red,
          fontSize: a.px16,
          fontWeight: FontWeight.w500,
        )
    ));
    list.add(Text(
        content2,
        style: TextStyle(
          color: Colors.black87,
          fontSize: a.px16,
          fontWeight: FontWeight.w500,
        )
    ));

    list.add(
      Icon(Icons.arrow_forward_ios, color: Colors.black26, size: a.px20),
    );

    return InkWell(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: px12, right: px12, top: px12, bottom: px12),
        child: Row(
          children: list,
        ),
      ),
      onTap: () async{
        final CouponData data = await Utils.navigateTo(CouponSelectPage(_coupons, _selectedCoupon?.id));
        if(data != null){
          setState(() {
            if(data.id == _selectedCoupon?.id)
              _selectedCoupon = null;
            else
              _selectedCoupon = data;
          });
        }
      },
    );
  }

  _buildItemList() {
    final Color blackColor = Colors.black87;
    final divider = Divider(height: 0, indent: a.px16, color: Colors.black38,);
    List<Widget> list = [];
    list.add(_buildItemView('杠杆本金', '${data.capital} 元', CustomColors.red));
    list.add(divider);

    if(data.contractType == ContractApplyDetailData.normalType){
      list.add(_buildItemView('担保费', data.strCost, CustomColors.red, data.strCostTips));
      list.add(divider);
      list.add(_buildItemView('利息', data.strInterest, CustomColors.red, data.strCostTips));
      list.add(divider);
    }

    list.add(_buildItemView('警戒线', '${data.cordon} 元', blackColor, null, true, () => alert2('警戒线', '触及警戒线会被限制买入，只能卖出。请密切关注并及时追加保证金至警戒线', '知道了')));
    list.add(divider);

    list.add(_buildItemView('止损线', '${data.cut} 元', blackColor, null, true, () => alert2('止损线', '当触及止损线，即会被强制平仓', '知道了')));
    list.add(divider);

    if(data.holdTips != null){
      list.add(_buildItemView('单票持仓', data.holdTips, blackColor), );
      list.add(divider);
    }

    list.add(_buildItemView('开始交易', data.date, blackColor), );
    list.add(divider);

    list.add(_buildItemView('持仓时间', data.period, blackColor), );

    if(_coupons != null && _coupons.length > 0) {
      list.add(divider);
      list.add(_buildCouponItemView());
    }

    return Column(
      children: list,
    );
  }

  _buildAgreeView() {
    return Container(
      margin: EdgeInsets.only(top: a.px5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '申请即表示已阅读并同意',
            style: TextStyle(
              color: Colors.black87,
              fontSize: a.px16,
            ),
          ),
          FlatButton(
            child: Text(
              '《操盘协议》',
              style: TextStyle(
                color: Colors.black87,
                fontSize: a.px16,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: (){
              String url;
              if(data.contractType == ContractApplyDetailData.experienceType){
                url = '${Global.host}api/v1/eprotocol?id=${data.experienceId}';
              }
              else{
                url = '${Global.host}api/v1/protocol?times=${data.times}&loanAmount=${data.loadAmount}&type=${data.type}&board=${data.board}';
              }

              final Map<String, String> headers = {
                "Accept": "*/*",
                'token': AccountData.getInstance().token,
              };
              Utils.navigateTo(WebViewPage(title: '操盘协议', url: url, headers: headers));
            },
          )
        ],
      ),
    );
  }

  _buildButton() {
    return Container(
      width: a.screenWidth,
      height: a.px50,
      child: RaisedButton(
        child: Text(
          '立即申请',
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: _onPressedNext,
        color: Colors.black,
      ),
    );
  }

  _onPressedNext() async{
    if(!await askAgreeRisk())
      return;

    if(data.contractType == ContractApplyDetailData.experienceType)
      _applyExperience();
    else
      _applyContract();
  }

  _applyExperience() async {
    if(!await Utils.showConfirmOptionsDialog(tips: data.trialConfirmTips, confirmTitle: '立即申请'))
      return;

    ResultData result = await ExperienceRequest.applyContract(data.experienceId);
    if(result.success){
      await UserRequest.getUserInfo();
      await alert('体验申请成功');
      Utils.navigatePopAll(AppTabIndex.experience);
    }
  }

  _applyContract() async {
    int integral = data.integral - (_selectedCoupon?.cost ?? 0);
    if(integral < 0) integral = 0;

    if(!await ContractApplyConfirmDialog.show(data.payment, integral))
      return;

    ResultData result = await ContractRequest.applyContract(data.type, data.board, data.times, data.loadAmount, _selectedCoupon?.id);
    if(result.success){
      if(result.data['code'] == 504){
        bool confirm = await Utils.showConfirmOptionsDialog(title: '提示', tips: '您的现金余额不足', confirmTitle: '立即充值');
        if(confirm){
          Utils.navigateTo(RechargePage());
        }
        return;
      }
      await UserRequest.getUserInfo();
      await alert('合约申请成功');
      Utils.navigatePopAll(AppTabIndex.trade);
    }
  }

  Future<bool> askAgreeRisk() async{
    if(AccountData.getInstance().agreedRisk)
      return Future.value(true);

    String text = await Utils.loadTextAsset(TextAssets.riskTips);
    var agree = await CustomDialog.showCustomDialog(
      Container(
        padding: EdgeInsets.fromLTRB(a.px16, a.px16, a.px16, a.px10),
        color: Colors.white,
        width: a.screenWidth * 0.8,
        height: a.screenHeight* 0.5,
        child: Column(
          children: <Widget>[
            Text('风险揭示', style: TextStyle(fontSize: a.px19, fontWeight: FontWeight.w500)),
            Expanded(
              child: SingleChildScrollView(
                child: Text(text, style: TextStyle(fontSize: a.px16),),
              ),
            ),
            Divider(height: 0),
            SizedBox(height: a.px10,),
            InkWell(
              child: Text('已阅读且同意此协议', style: TextStyle(fontSize: a.px20, color: Colors.blue, fontWeight: FontWeight.w400),),
              onTap: () => Utils.navigatePop(true),
            )
          ],
        ),
      )
    );

    if(agree != null){
      ResultData result = await UserRequest.agreeRisk();
      AccountData.getInstance().agreedRisk = result.success;
      return result.success;
    }

    return false;
  }
}

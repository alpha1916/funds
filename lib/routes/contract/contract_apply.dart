import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/routes/contract/contract_apply_detail.dart';
import 'package:funds/network/contract_request.dart';

class ContractApplyPage extends StatefulWidget {
  Map<int, List<ContractApplyItemData>> configs;
  final int type;
  ContractApplyPage(this.configs, [this.type = 0]);
  @override
  _ContractApplyPageState createState() => _ContractApplyPageState();
}

class _ContractApplyPageState extends State<ContractApplyPage> {
  List<ContractApplyItemData> dataList;
  int _currentTypeIdx = 0;
  int _currentTimesIdx = 0;
  int _inputLoadAmount;
  int _currentBoardIdx = 0;

  @override
  void initState() {
    super.initState();

    dataList = getDataList();
    ContractApplyItemData currentData;
    if(widget.type == 0){
      currentData = dataList[0];
      _currentTypeIdx = 0;
    }else{
      currentData = dataList.firstWhere((data) => data.type == widget.type);
      _currentTypeIdx = dataList.indexOf(currentData);
    }

    if(Global.debug){
      inputController.text = '10000';
      _onInputChanged('10000');
    }
  }

  getDataList() {
    return widget.configs[_currentBoardIdx + 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('申请合约'),
        actions: [
          Utils.buildMyTradeButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildTypeChipsView(a.px(80)),
          Divider(height: 0),
          _buildBoardChipsView(a.px(80)),
          Divider(height: 0),
          SizedBox(height: a.px10),
          _inputView(a.px(104)),
          SizedBox(height: a.px10),
          Container(
            width: double.infinity,
            height: a.px50,
            child: RaisedButton(
                child: Text(
                '下一步',
                style: TextStyle(color: Colors.white, fontSize: a.px18),
            ),
            onPressed: _onPressedNext,
            color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  _onPressedNext() async {
    print('type:$_currentTypeIdx:times:$_currentTimesIdx');
    if(inputController.text.length == 0){
      alert('请输入申请金额');
      return;
    }

    if(_inputLoadAmount == null){
      alert('请输入正确的数值');
      return;
    }
    final data = dataList[_currentTypeIdx];
    final min = data.min;
    if(_inputLoadAmount < min){
      alert('额度不能小于$min');
      return;
    }

    if(_inputLoadAmount % 1000 != 0){
      alert('请输入千的整数倍');
      return;
    }

    ContractApplyItemData selectedData = dataList[_currentTypeIdx];
    final times = selectedData.timesList[_currentTimesIdx];
    final ResultData result =  await ContractRequest.preApplyContract(selectedData.type, _currentBoardIdx + 1, times, _inputLoadAmount);
    if(result.success){
      ContractApplyDetailData data = result.data;
      data.title = selectedData.title;
      data.capital = (_inputLoadAmount / times).round();
      data.total = data.capital + _inputLoadAmount;
      data.period = '${selectedData.timeLimit}，到期不可续约';

      data.type = selectedData.type;
      data.times = times;
      data.loadAmount = _inputLoadAmount;
      data.board = _currentBoardIdx + 1;

      Utils.navigateTo(ContractApplyDetailPage(data));
    }
  }

  final _boardTitles = ['主板(创)', '科创板', '蓝筹版'];
  _buildBoardChipsView(chipSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: a.px20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _boardTitles.map((title) => _buildBoardChip(_boardTitles.indexOf(title), title, chipSize)).toList(), //要显示的子控件集合
      ),
    );
  }

  Widget _buildBoardChip(idx, title, size) {
    Color titleColor;
    Color borderColor;
    Color bgColor;

    if (_currentBoardIdx == idx) {
      titleColor = Colors.white;
      borderColor = Colors.orange;
      bgColor = Colors.orange;
    } else {
      titleColor = Colors.black;
      borderColor = Colors.grey;
      bgColor = Colors.white;
    }

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(a.px5)),
          border: Border.all(color: borderColor, width: a.px1), // 边色与边宽度
        ),
        width: a.px(100),
        height: size * 0.6,
        child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: size * 0.22,
                color: titleColor,
              ),
            )),
      ),
      onTap: () {
        if (_currentBoardIdx != idx) {
          setState(() {
            _currentBoardIdx = idx;
            _currentTypeIdx = 0;
            dataList = getDataList();
            inputController.clear();
            _inputLoadAmount = null;
          });
        }
      },
    );
  }

  Widget _buildTypeChip(idx, title, size) {
    Color titleColor;
    Color borderColor;
    Color bgColor;

    if (_currentTypeIdx == idx) {
      titleColor = Colors.white;
      borderColor = CustomColors.red;
      bgColor = CustomColors.red;
    } else {
      titleColor = Colors.black;
      borderColor = Colors.grey;
      bgColor = Colors.white;
    }

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(a.px5)),
          border: Border.all(color: borderColor, width: a.px1), // 边色与边宽度
        ),
        width: size,
        height: size * 0.6,
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: size * 0.22,
            color: titleColor,
          ),
        )),
      ),
      onTap: () {
        if (_currentTypeIdx != idx) {
          setState(() {
            _currentTypeIdx = idx;
            inputController.clear();
            _inputLoadAmount = null;
          });
        }
      },
    );
  }

  _buildTypeChipsView(chipSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: a.px20),
      child: Wrap(
        spacing: chipSize * 0.2, //主轴上子控件的间距
        runSpacing: chipSize * 0.1, //交叉轴上子控件之间的间距
        children: dataList.map((data) => _buildTypeChip(dataList.indexOf(data), data.title, chipSize)).toList(), //要显示的子控件集合
      ),
    );
  }

  TextEditingController inputController = TextEditingController();
  Widget _buildTextFiled(hintText) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: a.px30, right: a.px30),
      child: Container(
        child: TextField(
          textAlign: TextAlign.center,
          controller: inputController,
          cursorColor: Colors.black12,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            labelStyle: TextStyle(fontSize: a.px30),
          ),
          autofocus: false,
          onChanged: _onInputChanged,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: a.px(0.5)), // 边色与边宽度
        ),
      )
    );
  }
  
  _onInputChanged(text){
    int amount = Utils.parseInt(text);
    if(_inputLoadAmount != amount){
      setState(() {
        _inputLoadAmount = amount;
      });
    }
  }

  _getHintText(min, max) {
    String minText = min < 10000 ? min.toString() : '${min / 10000}万';
    String maxText = max < 10000 ? max.toString() : '${max / 10000}万';
    return '$minText元起配，最高$maxText元';
  }

  Widget _buildTimesItem(idx, times, min, size) {
    Color titleColor;
    Color borderColor;
    Color bgColor;
    String title = '杠杆本金';
    bool selectable = false;

    if(_inputLoadAmount != null){
      selectable = _inputLoadAmount >= min;

      if(selectable){//满足最小值
        if(_currentTimesIdx == idx){
          titleColor = Colors.white;
          borderColor = CustomColors.red;
          bgColor = CustomColors.red;
        }
        else {
          titleColor = Colors.black54;
          borderColor = Colors.grey;
          bgColor = Colors.white;
        }
      }else{
        titleColor = Colors.black54;
        borderColor = Colors.grey;
        bgColor = Colors.grey;
      }


      title = '${(_inputLoadAmount / times).round()}元';
    }else{
      titleColor = Colors.white;
      borderColor = Colors.grey;
      bgColor = Colors.grey;
    }

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(a.px5)),
          border: Border.all(color: borderColor, width: a.px1), // 边色与边宽度
        ),
        width: size,
        height: size * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$times倍',
                style: TextStyle(
                  fontSize: size * 0.15,
                  color: titleColor,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: size * 0.18,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if(!selectable)
          return;

        if (_currentTimesIdx != idx) {
          setState(() {
            _currentTimesIdx = idx;
          });
        }
      },
    );
  }
  
  Widget _timesItemsView(itemSize, min, timesList) {
    return Expanded(
      child: SingleChildScrollView(
        child: Wrap(
          spacing: itemSize * 0.2, //主轴上子控件的间距
          runSpacing: itemSize * 0.1, //交叉轴上子控件之间的间距
          children: timesList.map<Widget>((times) => _buildTimesItem(timesList.indexOf(times), times, min, itemSize)).toList(), //要显示的子控件集合
        ),
      ),
    );
  }

  Widget _inputView(itemSize) {
    final ContractApplyItemData data = dataList[_currentTypeIdx];
    final min = data.min;
    final max = data.max;
    final timesList = data.timesList;
    return Expanded(
      child: Center(
        child: Column(
          children: <Widget>[
            Text('请输入申请资金', style: TextStyle(fontSize: a.px16)),
            SizedBox(height: a.px10),
            _buildTextFiled(_getHintText(min, max)),
            SizedBox(height: a.px10),
            Text('请选择杠杠本金', style: TextStyle(fontSize: a.px16)),
            SizedBox(height: a.px10),
            _timesItemsView(itemSize, min, timesList),
          ],
        ),
      )
    );
  }
}

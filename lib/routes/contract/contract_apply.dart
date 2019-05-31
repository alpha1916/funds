import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/routes/contract/contract_apply_detail.dart';

var ctx;
class ContractApplyPage extends StatefulWidget {
  final int type;
  ContractApplyPage([this.type = 0]);
  @override
  _ContractApplyPageState createState() => _ContractApplyPageState(type);
}

class _ContractApplyPageState extends State<ContractApplyPage> {
  _ContractApplyPageState(int type){
    final data = _dataList.where((data) => data['type'] == type);
    _currentTypeIdx = _dataList.indexOf(data);
  }
  var _dataList = [];
  int _currentTypeIdx = 0;
  int _currentTimesIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    _dataList = [
      {
        'type' : 0,
        'title': '天天盈',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7, 8,9,10, 11, 12, 13, 49,50]
      },
      {
        'type' : 1,
        'title': '周周盈',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7]
      },
      {
        'type' : 2,
        'title': '月月盈',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7]
      },
      {
        'type' : 3,
        'title': '互惠盈',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7]
      },
      {
        'title': '互惠盈',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7]
      },
    ];
    final realWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('申请合约'),
        actions: [
          FlatButton(
            child: const Text('我的交易'),
            onPressed: () {
              print('press trade');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _chipsView(realWidth * 0.2),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.black26,
            height: 1,
          ),
          SizedBox(height: 10),
          _inputView(realWidth * 0.25),
          SizedBox(height: 10),
          Container(
            width: realWidth,
            height: adapt(50, realWidth),
            child: RaisedButton(
                child: Text(
                '下一步',
                style: TextStyle(color: Colors.white, fontSize: adapt(18, realWidth)),
            ),
            onPressed: _onPressedNext,
            color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  _onPressedNext() {
    print('type:$_currentTypeIdx:times:$_currentTimesIdx');
    if(inputController.text.length == 0){
      alert(ctx, '请输入申请金额');
      return;
    }

    final inputNum = int.parse(inputController.text);
    final data = _dataList[_currentTypeIdx];
    final min = data['min'];
    if(inputNum < min){
      alert(ctx, '额度不能小于$min');
      return;
    }

    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (_) {
            return ContractApplyDetailPage(ContractApplyDetailPage.getTestData());;
          }),
    );

  }

//  _selectable() {
//    if(inputController.text.length == 0)
//      return false;
//
//    final num = int.parse(inputController.text);
//    return num >= _dataList[_currentTypeIdx]['min'];
//  }

  Widget _buildChip(idx, title, size) {
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

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: borderColor, width: 1), // 边色与边宽度
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
          });
        }
      },
    );
  }

  _chipsView(chipSize) {
    return Center(
      child: Wrap(
        spacing: chipSize * 0.2, //主轴上子控件的间距
        runSpacing: chipSize * 0.1, //交叉轴上子控件之间的间距
        children: _dataList.map((data) {
          return _buildChip(_dataList.indexOf(data), data['title'], chipSize);
        }).toList(), //要显示的子控件集合
      ),
    );
  }

  TextEditingController inputController = TextEditingController();
  Widget _buildTextFiled(hintText) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Container(
        child: TextField(
          textAlign: TextAlign.center,
          controller: inputController,
          keyboardType: TextInputType.number,
          cursorColor: Colors.black12,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            labelStyle: TextStyle(fontSize: 30),
          ),
          autofocus: false,
          onChanged: (text) => setState((){}),
        ),
        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey, width: 0.5), // 边色与边宽度
        ),
      )
    );
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

    int inputNum = 0;
    if(inputController.text.length > 0){
      inputNum = int.parse(inputController.text);
      selectable = inputNum >= min;

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


      title = '${(inputNum / times).round()}元';
    }else{
      titleColor = Colors.white;
      borderColor = Colors.grey;
      bgColor = Colors.grey;
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: borderColor, width: 1), // 边色与边宽度
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
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: itemSize * 0.2, //主轴上子控件的间距
              runSpacing: itemSize * 0.1, //交叉轴上子控件之间的间距
              children: timesList.map<Widget>((times) {
                return _buildTimesItem(timesList.indexOf(times), times, min, itemSize);
              }).toList(), //要显示的子控件集合
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputView(itemSize) {
    final data = _dataList[_currentTypeIdx];
    final min = data['min'];
    final max = data['max'];
    final timesList = data['timesList'];
    return Expanded(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              '请输入申请资金',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            _buildTextFiled(_getHintText(min, max)),
            SizedBox(height: 10),
            Text('请选择杠杠本金', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            _timesItemsView(itemSize, min, timesList),
          ],
        ),
      )
    );
  }
}

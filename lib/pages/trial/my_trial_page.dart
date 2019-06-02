import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/model/contract_data.dart';

class MyTrialPage extends StatefulWidget {
  @override
  _MyTrialPageState createState() => _MyTrialPageState();
}

class _MyTrialPageState extends State<MyTrialPage> {
  List<ContractData> _dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var _oDataList = [
      {'title':'免费体验', 'ongoing' : true, 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'title':'免息体验', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
    ];

    _dataList = _oDataList.map((data) {
      data['type'] = ContractType.trial;
      return ContractData(data);
    }).toList();
//    _dataList = [
//      {'type': 0, 'startPrice': 2000, 'minRate': 3, 'maxRate': 10},
//      {'type': 1, 'startPrice': 2000, 'minRate': 3, 'maxRate': 8},
//      {'type': 2, 'startPrice': 2000, 'minRate': 3, 'maxRate': 6},
//      {'type': 3, 'startPrice': 1000, 'minRate': 6, 'maxRate': 8},
//    ];
  }

  @override
  Widget build(BuildContext context) {
    final realWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            margin: EdgeInsets.only(top: adapt(10, realWidth)),
//            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(data, realWidth, () {
              print('select $index');
            }),
            alignment: Alignment.center,
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }
}

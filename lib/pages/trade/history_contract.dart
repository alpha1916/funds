import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../contract_item.dart';

class HistoryContractPage extends StatefulWidget {
  @override
  _HistoryContractPageState createState() => _HistoryContractPageState();
}

class _HistoryContractPageState extends State<HistoryContractPage> {
  var _dataList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataList = [
      {'title': '免费体验', 'ongoing' : true, 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'title': '免息体验', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
      {'title': '天天盈', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
      {'title': '天天盈T+1', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
    ];

    return Container(
      color: CustomColors.background1,
//      child: Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(
              ContractType.history,
              data['title'],
              false,
              data['startDate'],
              data['endDate'],
              data['total'],
              data['contract'],
              data['profit'],
            ),
            alignment: Alignment.center,
          );
        },
        itemCount: _dataList.length,
      ),
//      ),
    );
  }
}


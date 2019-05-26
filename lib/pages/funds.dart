import 'package:flutter/material.dart';
import '../common/constants.dart';


class FundsView extends StatefulWidget {
  @override
  _FundsViewState createState() => _FundsViewState();
}

class _FundsViewState extends State<FundsView> {
  List<Map<String, int>> _dataList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('配资'),
      ),
      body: Column(
//        color: Colors.red,
//        child: _ItemView(0, 1000, 3, 8),
        children: <Widget>[
          _itemListView(),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataList = [
      {'type': 0, 'startPrice': 2000, 'minRate': 3, 'maxRate': 10},
      {'type': 1, 'startPrice': 2000, 'minRate': 3, 'maxRate': 8},
      {'type': 2, 'startPrice': 2000, 'minRate': 3, 'maxRate': 6},
      {'type': 3, 'startPrice': 1000, 'minRate': 6, 'maxRate': 8},
    ];
  }

  _itemListView () {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            child: _ItemView(data['type'], data['startPrice'], data['minRate'], data['maxRate']),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final int type;
  final int minRate;
  final int maxRate;
  final int startPrice;

  createView() {
//    final texts = Constants.itemTextList[type];

    final String trayImagePath = CustomIcons.fundsPeriodTrayPrefix + type.toString() + '.png';
    return Container(
      child: Image.asset(trayImagePath,
          fit: BoxFit.fitWidth
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('item view type:$type');
    return GestureDetector(
      child: createView(),
      onTap: () {
        print('press item type:$type');
      },
    );
  }

  _ItemView(this.type, this.startPrice, this.minRate, this.maxRate);
}
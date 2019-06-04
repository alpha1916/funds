
import 'package:funds/model/contract_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/stock_trade_data.dart';

class HttpRequest {
  static Future<List<ContractApplyItemData>> getApplyItemList() async{
    var testDataList = [
      {
        'type' : 0,
        'title': '天天盈',
        'interest': '按天计息',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7, 8,9,10]
      },
      {
        'type' : 1,
        'title': '周周盈',
        'interest': '按周计息',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6, 7, 8]
      },
      {
        'type' : 2,
        'title': '月月盈',
        'interest': '按月盈息',
        'min': 2000,
        'max': 5000000,
        'timesList': [3, 4, 5, 6]
      },
      {
        'type' : 3,
        'title': '互惠盈',
        'interest': '免管理费',
        'min': 1000,
        'max': 5000000,
        'timesList': [6, 7, 8]
      },
    ];

//    await Future.delayed(Duration(milliseconds: 3000));

    final List<ContractApplyItemData> list = testDataList.map((data) => ContractApplyItemData(data)).toList();
//    return list;
    return Future.value(list);
  }

  static Future<ContractApplyDetailData> getApplyItemDetail() {
    var testData = {
      'title': '互惠盈T+1',
      'profit': 90,
      'total': 1167,
      'capital': 167,
      'cost': 0,
      'cordon': 1084,
      'cut': 1050,
      'date': '2019-05-22',
      'holdTips': '主板单票100%，创业板总仓位100%',
      'period': '2个交易日，到期不可续约',
      'coupons': [
        {'cost': 50, 'title': '管理费抵用券', 'date': '2019-06-29'},
        {'cost': 200, 'title': '管理费抵用券', 'date': '2019-06-29'},
        {'cost': 1000, 'title': '管理费抵用券', 'date': '2019-06-29'},
      ],
    };
    final ContractApplyDetailData data = ContractApplyDetailData(testData);
    return Future.value(data);
  }

  static Future<CurrentContractDetailData> getCurrentContractDetail() async{
    var testData = {
      'title': '互惠盈T+1',
      'total': 5004.06,
      'cash': 0.00,
      'profit': -930.09,
      'capital': 167.00,
      'cost': 0.00,
      'cordon': 5500.00,
      'cut': 5300.00,
      'info': '142791870591850',
      'loan': 5000.00,
      'contract': 6000.00,
      'stocks': 6080.86,
      'days': 11,
    };

    final CurrentContractDetailData data = CurrentContractDetailData(testData);
    return data;

  }

  static Future<List<ContractData>> getCurrentContractList() async{
    print('getCurrentContractList');
    var testData = [
      {'title': '免费体验', 'ongoing' : true, 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'title': '免息体验', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
      {'title': '天天盈', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
      {'title': '天天盈T+1', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
    ];

    final dataList = testData.map((data) {
      data['type'] = ContractType.current;
      data['ongoing'] = true;
      return ContractData(data);
    }).toList();

    return dataList;
  }

  static Future<List<StockData>> getStockHoldList() async{
    print('getStockHoldList');
    var testDataList = [
      {'title': '天山生物', 'code': 606666, 'value': 3918.00, 'profit': -440.70, 'hold': 600, 'usable': 0, 'cost': 7.26, 'price': 6.53},
      {'title': '紫金银行', 'code': 606666, 'value': 1440000.00, 'profit': 1240000.70, 'hold': 600, 'usable': 0, 'cost': 7.26, 'price': 8.53},
    ];

    final dataList = testDataList.map((data) => StockData(data)).toList();

    return dataList;
  }

  static Future<List<StockCancelData>> getStockCancelList() async{
    print('getStockHoldList');
    var testDataList = [
      {'title': '天山生物', 'code': 606666,  'price': 6.53, 'count': 600, 'type': 1, 'strDay': '2019-05-31', 'strTime': '09:30:10'},
      {'title': '天山生物', 'code': 606666,  'price': 8.53, 'count': 600, 'type': -1, 'strDay': '2019-05-31', 'strTime': '09:30:10'},
    ];

    final dataList = testDataList.map((data) => StockCancelData(data)).toList();

    return dataList;
  }

  static  TradingStockData getTradingStockData(int code) {
    var testData = {
      'title': '工商银行',
      'code': 666666,
      'closingPrice': 3.00,
      'upLimitPrice': 3.30,
      'downLimitPrice': 2.70,
      'buyList': [
        [2.94, 100],
        [2.93, 2000],
        [2.92, 300],
        [2.91, 4000],
        [2.90, 5000],
      ],
      'sellList': [
        [3.09, 1000],
        [3.11, 2000],
        [3.12, 3000],
        [3.13, 4000],
        [13.14, 5000],
      ],
    };

    final TradingStockData data = TradingStockData(testData);
    return data;

  }
}
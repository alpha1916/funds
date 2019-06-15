import 'dart:async';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/stock_trade_request.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/model/contract_data.dart';

class TradeBloc {
  String contractNumber;
  StockHoldData selectedHoldData;

  TradingStockData _stockInfo;
  TradingStockData get stockInfo => _stockInfo;
  Stream<TradingStockData> get stockStream => _stockInfoController.stream;
  var _stockInfoController = StreamController<TradingStockData>.broadcast();

  int _usableCount = 0;
  int get usableCount => _usableCount;
  Stream<int> get countStream => _countController.stream;
  var _countController = StreamController<int>.broadcast();

  int _saleableCount = 0;
  int get saleableCount => _saleableCount;
  Stream<int> get saleableCountStream => _saleableCountController.stream;
  var _saleableCountController = StreamController<int>.broadcast();

  double _money = 2000.00;
  double get money => _money;
  Stream<double> get moneyStream => _moneyController.stream;
  var _moneyController = StreamController<double>.broadcast();

  List<StockHoldData> _holdList = [];
  List<StockHoldData>  get holdList => _holdList;
  Stream<List<StockHoldData> > get holdListStream => _holdListController.stream;
  var _holdListController = StreamController<List<StockHoldData>>.broadcast();

  setContractNumber(contractNumber){
    this.contractNumber = contractNumber;
  }

  getStockInfo(code) async {
    ResultData result = await StockTradeRequest.getStockInfo(code);
    TradingStockData _stockInfo;
    if(result.success){
      _stockInfo = result.data;
    }
    print('getStockInfo,stock:$_stockInfo');
    _stockInfoController.add(_stockInfo);
  }

  clearStockInfo() {
    _stockInfoController.add(null);
  }

  updateUsableCount(double price){
    int count = 0;
    if(price > 0 && _money > 0){
      count = _money ~/ price;
      count = count - count % 100;
    }

    if(count != _usableCount){
      _usableCount = count;
      _countController.add(_usableCount);
    }
  }

  updateSaleableCount(code) {
    print('holdList.length:${holdList.length}');
    int count = 0;
    if(code != null && holdList != null && holdList.length > 0){
      selectedHoldData = holdList.firstWhere((data) => data.code == code);
      if(selectedHoldData != null)
        count = selectedHoldData.usable;
    }
    if(count != _saleableCount){
      _saleableCount = count;
      _saleableCountController.add(_saleableCount);
    }
  }

  updateMoney() async{
    ResultData result = await ContractRequest.getContractDetail(contractNumber);
    if(result.success){
      ContractData data = result.data;
      if(_money != data.usableMoney){
        _money = data.usableMoney;
        _moneyController.add(_money);
      }
    }
  }

  updateHoldList() async {
    ResultData result = await StockTradeRequest.getHoldList(contractNumber);
    print('updateHoldList');
    _holdList = [];
    if(result.success){
      _holdList = result.data;
    }
    _holdListController.add(_holdList);
  }

  dispose() {
    _stockInfoController.close();
    _countController.close();
    _saleableCountController.close();
    _moneyController.close();
    _holdListController.close();
  }

  refresh() {
    print('trade bloc refresh');
    updateMoney();
    updateHoldList();
  }

  static TradeBloc bloc;
  static TradeBloc getInstance() {
    if(bloc == null){
      bloc = TradeBloc();
    }
    return bloc;
  }
}
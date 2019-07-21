import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/common/utils.dart';
import 'history_contract_detail.dart';

import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';

class HistoryContractListPage extends StatefulWidget {
  @override
  _HistoryContractListPageState createState() => _HistoryContractListPageState();
}

class _HistoryContractListPageState extends State<HistoryContractListPage> {
  ListPageDataHandler listPageDataHandler;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    listPageDataHandler = ListPageDataHandler(
        itemConverter: (data) => ContractData(data),
        requestDataHandler: (pageIndex, pageCount) async{
          var result = await ContractRequest.getContractList(1, pageIndex, pageCount);
          return result.data;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshListView(
      indexedWidgetBuilder: _itemBuilder,
      refreshHandler: listPageDataHandler.refresh,
      loadMoreHandler: listPageDataHandler.loadMore,
    );
  }

  Widget _itemBuilder(BuildContext context, int index, dynamic data){
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: ContractItemView(ContractType.history, data, () {
        print('select $index');
        Utils.navigateTo(HistoryContractDetail(data));
      }),
      alignment: Alignment.center,
    );
  }
}


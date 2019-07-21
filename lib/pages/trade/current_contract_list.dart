import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/pages/contract_item_view.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/routes/contract/contract_apply.dart';

import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';

class CurrentContractListPage extends StatefulWidget {
  @override
  _CurrentContractListPageState createState() => _CurrentContractListPageState();
}

class _CurrentContractListPageState extends State<CurrentContractListPage> {
  ListPageDataHandler listPageDataHandler;
  GlobalKey<CustomRefreshListViewState> _listViewKey = GlobalKey<CustomRefreshListViewState>();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    listPageDataHandler = ListPageDataHandler(
        itemConverter: (data) => ContractData(data),
        requestDataHandler: (pageIndex, pageCount) async{
          var result = await ContractRequest.getContractList(0, pageIndex, pageCount);
          return result.data;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshListView(
      key: _listViewKey,
      indexedWidgetBuilder: _itemBuilder,
      refreshHandler: listPageDataHandler.refresh,
      loadMoreHandler: listPageDataHandler.loadMore,
      noDataViewBuilder: _buildPromoteView,
    );
  }

  _showContractDetail(data) async{
    await Utils.navigateTo(CurrentContractDetail(data));
    _refresh();
  }

  _refresh(){
    _listViewKey.currentState.refresh();
  }

  _buildPromoteView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: a.px20),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Center(child: Text('当前没有操盘中的合约', style: TextStyle(fontSize: a.px14, color: Colors.black26)),),
                FlatButton(
                  child: Text(
                    '申请合约享受盈利翻倍',
                    style: TextStyle(
                      fontSize: a.px16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () async{
                    ResultData result = await ContractRequest.getConfigs();
                    if(mounted && result.success){
                      await Utils.navigateTo(ContractApplyPage(result.data));
                      _refresh();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index, dynamic data){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: a.px10),
      child: ContractItemView(ContractType.current, data, () => _showContractDetail(data)),
    );
  }
}


import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<int> flexes;
  final List<Widget> headerColumns;
  final rowBuilder;
  final List<dynamic> dataList;
  CustomDataTable({
    this.flexes,
    this.headerColumns,
    this.rowBuilder,
    this.dataList,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildDataColumns(),
        ],
      ),
    );
  }
  _buildHeader() {
    return Row(
      children: headerColumns.map((item) =>
        Expanded(
          flex: flexes[headerColumns.indexOf(item)],
          child: item,
        )
      ).toList(),
    );
  }

  _buildDataColumns(){
    return Column(
      children: dataList.map<Widget>((data){
        return Row(
          children: List.generate(flexes.length, (index) {
            return Expanded(
              flex: flexes[index],
              child: rowBuilder(index),
            );
          }),
        );
      }).toList(),
    );
  }
}


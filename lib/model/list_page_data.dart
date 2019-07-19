typedef RequestDataHandler = dynamic Function(int pageIndex, int pageCount);

class ListPageDataHandler<T>{
//  final int pageNo;
//  final int pageSize;
//  final int totalPage;
//  final int total;
//  final int startIndex;
//  final List<T> dataList;
  ListPageDataHandler({
    this.itemConverter,
    this.requestDataHandler,
    this.pageCount = 10,
  });
  final itemConverter;
  final requestDataHandler;
  final int pageCount;

  int currentPageIndex;
  int totalPage;

  init() {
    currentPageIndex = 0;
    totalPage = -1;
  }

  Future<List<T>> refresh() async{
    init();

    var data = await this.requestDataHandler(0, pageCount);
    if(data == null)
      return [];

    currentPageIndex = data['pageNo'];
    totalPage = data['totalPage'];
    List<dynamic> oDataList = data['result'];
    List<T> dataList = oDataList.map<T>((itemData) => itemConverter(itemData)).toList();
    return dataList;
  }

  Future<List<T>> loadMore() async{
    if(totalPage == currentPageIndex){
      print('no more data');
      return null;
    }

    var data = await this.requestDataHandler(currentPageIndex, pageCount);
    if(data == null)
      return null;

    currentPageIndex = data['pageNo'];
    totalPage = data['totalPage'];
    List<dynamic> oDataList = data['result'];
    print('currentPageIndex:$currentPageIndex, totalPage:$totalPage');
    List<T> dataList = oDataList.map<T>((itemData) => itemConverter(itemData)).toList();
    return dataList;
  }
}

class ListPageData{
  final int currentPageIndex;
  final bool end;
  final dataList;
  ListPageData(this.currentPageIndex, this.end, this.dataList);

  static buildPageData(pageIndex, pageCount){
    return {
      'currentPage': pageIndex,
      'pageSize': pageCount,
    };
  }
}
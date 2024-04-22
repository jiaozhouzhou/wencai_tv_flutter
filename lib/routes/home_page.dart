import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../widgets/left_tab_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/poster_item.dart';
import '../widgets/bg_container.dart';
import 'package:provider/provider.dart';
import '../states/index.dart' show Config, User, Poster;
import '../utils/request.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusScopeNode topBtnScope = FocusScopeNode(); // 顶部按钮焦点区域
  final FocusScopeNode leftBtnScope = FocusScopeNode(); // 左侧导航焦点区域
  final FocusScopeNode listScope = FocusScopeNode(); // 海报列表焦点区域
  final ScrollController navBar = ScrollController();
  final ScrollController listCon = ScrollController();
  final GlobalKey leftBtnDom = GlobalKey();
  late List homeDate = [];
  List<FocusNode> nodeArr = <FocusNode>[];
  List<Widget> list = <Widget>[];
  int lastSelect = -1;

  void initNodeArr(){
    int i = 0;
    while (i < nodeArr.length) {
      // 调用当前 FocusNode 的 dispose 方法
      nodeArr[i].dispose();
      // 从列表中移除已 dispose 的 FocusNode
      nodeArr.removeAt(i);
    }
  }

  void leftBarChange(index){
    if(lastSelect==index) return;
    final arr = homeDate[index]['templates'];
    // 先重置focusNode
    initNodeArr();
    // 再重新分配列表的focusNode
    var fna = <FocusNode>[];
    var wgtArr = <Widget>[];
    var idArr = [];
    for(var item in arr) {
      final id = item['id'];
      final fn = FocusNode(debugLabel: 'poster$id');
      idArr.add(id);
      fna.add(fn);
      wgtArr.add(PosterItem(focusNode: fn, data: item));
    }
    setState(() {
      list = wgtArr;
      nodeArr = fna;
      lastSelect = index;
    });
    context.read<Poster>().setLoopSwitchPosterList(idArr);
  }

  void getHomeData(){
    HttpUtil().get("index/index", loading: true).then((res){
      // 更新首页数据
      setState(() {
        homeDate = res;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<User>();
    if(user.isLogin) {
      HttpUtil().post("member/memberInfo").then((res) {
        // 更新用户信息
        user.setUserInfo(res);
      });
      getHomeData();
    }
  }

  @override
  void dispose() {
    topBtnScope.dispose();
    leftBtnScope.dispose();
    listScope.dispose();
    navBar.dispose();
    listCon.dispose();
    initNodeArr();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<Config>();
    final bool isHorizontal = config.isHorizontal;
    final conObj = MediaQuery.of(context);
    final colNum = isHorizontal ? 7 : 3; // 列表展示一排展示几个
    final int totalNum = (nodeArr.length/colNum).floor(); // 列表总行数
    final int totalRemainder = nodeArr.length%colNum; // 列表最后一行的余数
    final double itemHeight = isHorizontal ? 293.6.w : 283.24.w;

    return Scaffold(
        // body: FutureBuilder(
        //   future: enterPage(context),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {

        body: BgContainer(
                isHorizontal: isHorizontal,
                child: SafeArea(
                    child: Column(
                      children:  <Widget>[
                        // 头部信息区域
                        FocusScope(
                            node: topBtnScope,
                            // autofocus: true,
                            debugLabel: 'topBtnScope',
                            onKeyEvent: (node, event) {
                              if(!topBtnScope.hasFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
                              // PhysicalKeyboardKey.arrowLeft;
                              if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                debugPrint('down');
                                if(isHorizontal){
                                  topBtnScope.unfocus();
                                  leftBtnScope.requestFocus();
                                }else if(!isHorizontal && list.isNotEmpty){
                                  topBtnScope.unfocus();
                                  listScope.requestFocus(nodeArr[0]);
                                }
                                debugPrint('到底部了，焦点转移到其他区域');
                              }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                                debugPrint('left');
                                if(config.orientation=='left'){ // 兼容270度时 左右焦点移动错误
                                  topBtnScope.nextFocus();
                                }else{
                                  topBtnScope.focusInDirection(config.correctDirection2(TraversalDirection.left));
                                }
                              }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                                debugPrint('right');
                                if(config.orientation=='left'){ // 兼容270度时 左右焦点移动错误
                                  topBtnScope.previousFocus();
                                }else{
                                  topBtnScope.focusInDirection(config.correctDirection2(TraversalDirection.right));
                                }
                              }
                              return KeyEventResult.handled;
                            },
                            child: HomeHeader(
                                isHorizontal: isHorizontal,
                                data: '',
                                reFreshFun: getHomeData,
                            )
                        ),
                        SizedBox(height: 22.w),
                        Flex(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            direction: isHorizontal ? Axis.vertical : Axis.horizontal,
                            children: <Widget>[
                              // 左侧导航
                              FocusScope(
                                  node: leftBtnScope,
                                  // autofocus: true,
                                  debugLabel: 'leftBtnScope',
                                  onKeyEvent: (node, event) {
                                    if(!leftBtnScope.hasFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
                                    if(isHorizontal){
                                      // 横版
                                      if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                        // 到顶了
                                        debugPrint('到顶了，焦点转移到 topBtnScope 区域');
                                        leftBtnScope.unfocus();
                                        topBtnScope.requestFocus();
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowDown && list.isNotEmpty) {
                                        debugPrint('到底部了，焦点转移到 listScope 区域 ');
                                        leftBtnScope.unfocus();
                                        listScope.requestFocus(nodeArr[0]);
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                                        debugPrint('left');
                                        navBar.jumpTo(132.w);
                                        // 兼容270度时 左右焦点移动错误
                                        config.orientation=='left'? leftBtnScope.nextFocus() : leftBtnScope.previousFocus();
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                                        debugPrint('right');
                                        navBar.jumpTo(-132.w);
                                        // 兼容270度时 左右焦点移动错误
                                        config.orientation=='left'? leftBtnScope.previousFocus() : leftBtnScope.nextFocus();
                                      }
                                    }else{
                                      // 竖版
                                      if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                        debugPrint('up');
                                        if(leftBtnScope.focusedChild==leftBtnScope.children.first){
                                          // 到顶了
                                          debugPrint('到顶了，焦点转移到 topBtnScope 区域');
                                          leftBtnScope.unfocus();
                                          topBtnScope.requestFocus();
                                        }else{
                                          navBar.jumpTo(132.w);
                                          leftBtnScope.previousFocus();
                                        }
                                        // FocusScope.of(context).focusInDirection(config.correctDirection2(TraversalDirection.up));
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                        debugPrint('down');
                                        navBar.jumpTo(-132.w);
                                        leftBtnScope.nextFocus();
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowRight && list.isNotEmpty){
                                        debugPrint('right');
                                        // 右键聚焦右侧列表，这里要取消聚焦
                                        leftBtnScope.unfocus();
                                        listScope.requestFocus(nodeArr[0]);
                                      }
                                    }
                                    return KeyEventResult.handled;
                                  },
                                  child: LeftTabBar(
                                      key: leftBtnDom,
                                      scrollController: navBar,
                                      isHorizontal: isHorizontal,
                                      data: homeDate,
                                      onValueChanged: leftBarChange,
                                  )
                              ),
                              SizedBox(width: 16.w, height: 16.w),
                              // 右侧内容列表
                              FocusScope(
                                  node: listScope,
                                  debugLabel: 'listScope',
                                  // autofocus: true,
                                  onKeyEvent: (node, event) {
                                    if(!listScope.hasFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
                                    if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                      final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                      // 到顶了
                                      if(lastIndex<colNum){
                                        debugPrint('到顶了，焦点转移到 leftBtnScope 区域333');
                                        listScope.unfocus();
                                        isHorizontal ? leftBtnScope.requestFocus() : topBtnScope.requestFocus();
                                      }else{
                                        debugPrint('up');

                                        final nowIndex = lastIndex-colNum;
                                        final int lineNum = (nowIndex/colNum).floor(); // 行数
                                        listCon.animateTo(lineNum * itemHeight, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                        nodeArr[nowIndex].requestFocus();

                                        // listScope.focusInDirection(config.correctDirection2(TraversalDirection.up));
                                        // final index = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                        // final int lineNum = (index/colNum).floor(); // 行数
                                        // debugPrint('焦点元素索引值：-- $index--${listScope.focusedChild}-----$lineNum');
                                        // listCon.animateTo(lineNum * itemHeight, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                      }
                                    }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                      final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                      debugPrint('down  $lastIndex');
                                      final nowIndex = lastIndex+colNum;
                                      final remainder = nowIndex%colNum; // 当前所在行的余数
                                      final int lineNum = (nowIndex/colNum).floor(); // 当前行数
                                      if(lineNum<totalNum || (lineNum==totalNum&&remainder<totalRemainder)){
                                        listCon.animateTo(lineNum * itemHeight, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                        nodeArr[nowIndex].requestFocus();
                                      }

                                      // listScope.focusInDirection(config.correctDirection2(TraversalDirection.down));
                                      // final index = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                      // final int lineNum = (index/colNum).floor(); // 行数
                                      // listCon.animateTo(lineNum * itemHeight, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                    }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                                      final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                      debugPrint('left  $lastIndex');
                                      final remainder = lastIndex%colNum;
                                      if(remainder==0){
                                        if(!isHorizontal){ // 竖版
                                          listScope.unfocus();
                                          leftBtnScope.requestFocus();
                                        }
                                      }else{
                                        nodeArr[lastIndex-1].requestFocus();
                                      }

                                      // int i = 1;
                                      // if(!isHorizontal) i = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                      // listScope.focusInDirection(config.correctDirection2(TraversalDirection.left));
                                      // if(!isHorizontal && i%colNum==0){ // 竖版
                                      //     listScope.unfocus();
                                      //     leftBtnScope.requestFocus();
                                      // }
                                    }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                                      final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                                      debugPrint('right33  $lastIndex');
                                      final remainder = lastIndex%colNum;
                                      if(remainder<(colNum-1) && (lastIndex<nodeArr.length-1)){
                                        nodeArr[lastIndex+1].requestFocus();
                                      }

                                      // listScope.focusInDirection(config.correctDirection2(TraversalDirection.right));
                                    }
                                    return KeyEventResult.handled;
                                  },
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Container(
                                        width: isHorizontal ? 1232.w : 524.w,
                                        // height: isHorizontal ? null : 1034.w,
                                        constraints: BoxConstraints(
                                          maxHeight: isHorizontal ? (527.w- conObj.padding.top) : 1034.w,
                                          // maxHeight: isHorizontal ? (470.h - conObj.padding.top) : 1034.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:  BorderRadius.circular(10.w),
                                        ),
                                        child: list.isNotEmpty ? GridView(
                                          controller: listCon,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(22.w),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: colNum, //横轴三个子widget
                                            crossAxisSpacing: 20.w, // 次轴
                                            mainAxisSpacing: 20.w, // 主轴
                                            childAspectRatio: 146.w/262.w,
                                          ),
                                          children: list,
                                        ) : const TDEmpty(
                                          type: TDEmptyType.plain,
                                          emptyText: '暂无数据',
                                        ),
                                      )
                                  )
                              )
                            ]
                        )
                      ],
                    )
                )
            )
          // }
        // )
    );
  }
}
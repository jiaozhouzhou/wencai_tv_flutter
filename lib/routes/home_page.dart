import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../widgets/left_tab_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/poster_item.dart';
import '../widgets/bg_container.dart';
import 'package:provider/provider.dart';
import '../states/config.dart';

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
  final nodeArr = <FocusNode>[];

  void initListFocusNode(){
    for (var i = 0; i < 30; i++) {
      final fn = FocusNode(debugLabel: 'poster$i');
      nodeArr.add(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initListFocusNode();
    super.initState();
  }

  @override
  void dispose() {
    topBtnScope.dispose();
    leftBtnScope.dispose();
    listScope.dispose();
    navBar.dispose();
    listCon.dispose();
    for(int i=0; i<nodeArr.length; i++){
      nodeArr[i].dispose();
    }
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
    final list = <Widget>[];
    for (var item in nodeArr) {
      list.add(PosterItem(focusNode: item));
    }

    return Scaffold(
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
                    if(!topBtnScope.hasFocus || event is! KeyDownEvent) return KeyEventResult.handled;
                    // PhysicalKeyboardKey.arrowLeft;
                    if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      print('down');
                      topBtnScope.unfocus();
                      isHorizontal ? leftBtnScope.requestFocus() : listScope.requestFocus();
                      print('到底部了，焦点转移到其他区域');
                    }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                      print('left');
                      if(config.orientation=='left'){ // 兼容270度时 左右焦点移动错误
                        topBtnScope.nextFocus();
                      }else{
                        topBtnScope.focusInDirection(config.correctDirection2(TraversalDirection.left));
                      }
                    }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                      print('right');
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
                    onValueChanged: (str){}
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
                        if(!leftBtnScope.hasFocus || event is! KeyDownEvent) return KeyEventResult.handled;
                        if(isHorizontal){
                          // 横版
                          if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            // 到顶了
                            print('到顶了，焦点转移到 topBtnScope 区域');
                            leftBtnScope.unfocus();
                            topBtnScope.requestFocus();
                          }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                            print('到底部了，焦点转移到 listScope 区域 ');
                            leftBtnScope.unfocus();
                            listScope.requestFocus();
                          }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                            print('left');
                            navBar.jumpTo(132.w);
                            leftBtnScope.previousFocus();
                          }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                            print('right');
                            navBar.jumpTo(-132.w);
                            leftBtnScope.nextFocus();
                          }
                        }else{
                          // 竖版
                          if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            print('up');
                            if(leftBtnScope.focusedChild==leftBtnScope.children.first){
                              // 到顶了
                              print('到顶了，焦点转移到 topBtnScope 区域');
                              leftBtnScope.unfocus();
                              topBtnScope.requestFocus();
                            }else{
                              navBar.jumpTo(132.w);
                              leftBtnScope.previousFocus();
                            }
                            // FocusScope.of(context).focusInDirection(config.correctDirection2(TraversalDirection.up));
                          }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                            print('down');
                            navBar.jumpTo(-132.w);
                            leftBtnScope.nextFocus();
                          }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                            print('right');
                            // 右键聚焦右侧列表，这里要取消聚焦
                            leftBtnScope.unfocus();
                            listScope.requestFocus();
                          }
                        }
                        return KeyEventResult.handled;
                      },
                      child: LeftTabBar(
                        key: leftBtnDom,
                        scrollController: navBar,
                        isHorizontal: isHorizontal,
                        data: '',
                        onValueChanged: (str){}
                      )
                    ),
                    SizedBox(width: 16.w, height: 16.w),
                    // 右侧内容列表
                    FocusScope(
                      node: listScope,
                      debugLabel: 'listScope',
                      onKeyEvent: (node, event) {
                        if(!listScope.hasFocus || event is! KeyDownEvent) return KeyEventResult.handled;
                        if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                          final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                          // 到顶了
                          if(lastIndex<colNum){
                            print('到顶了，焦点转移到 leftBtnScope 区域333');
                            listScope.unfocus();
                            isHorizontal ? leftBtnScope.requestFocus() : topBtnScope.requestFocus();
                          }else{
                            print('up');

                            final nowIndex = lastIndex-colNum;
                            final int lineNum = (nowIndex/colNum).floor(); // 行数
                            listCon.animateTo(lineNum * 283.w, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                            nodeArr[nowIndex].requestFocus();

                            // listScope.focusInDirection(config.correctDirection2(TraversalDirection.up));
                            // final index = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                            // final int lineNum = (index/colNum).floor(); // 行数
                            // print('焦点元素索引值：-- $index--${listScope.focusedChild}-----$lineNum');
                            // listCon.animateTo(lineNum * 283.w, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                          }
                        }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                          print('down');
                          final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                          final nowIndex = lastIndex+colNum;
                          final remainder = nowIndex%colNum; // 当前所在行的余数
                          final int lineNum = (nowIndex/colNum).floor(); // 当前行数
                          if(lineNum<totalNum || (lineNum==totalNum&&remainder<totalRemainder)){
                            listCon.animateTo(lineNum * 283.w, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                            nodeArr[nowIndex].requestFocus();
                          }

                          // listScope.focusInDirection(config.correctDirection2(TraversalDirection.down));
                          // final index = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                          // final int lineNum = (index/colNum).floor(); // 行数
                          // listCon.animateTo(lineNum * 283.w, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                        }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                          print('left');
                          final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
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
                          print('right33');
                          final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
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
                              crossAxisSpacing: 21.w, // 横轴间隙
                              mainAxisSpacing: 21.w,
                              childAspectRatio: 146/262,
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
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../widgets/left_tab_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/poster_item.dart';

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
  final nodeArr = <FocusNode>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < 30; i++) {
      final fn = FocusNode(debugLabel: 'poster$i');
      nodeArr.add(fn);
    }
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
    final conObj = MediaQuery.of(context);
    final bool isHorizontal = conObj.orientation == Orientation.landscape;
    final list = nodeArr.map((item)=>PosterItem(focusNode: item));

    return Scaffold(
        body: Container(
          width: conObj.size.width,
          height: conObj.size.height,
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.w),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/login_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                      topBtnScope.previousFocus();
                    }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                      print('top_right');
                      topBtnScope.nextFocus();
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
                        // print('${event.physicalKey}----${event.logicalKey}');
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
                            // FocusScope.of(context).focusInDirection(TraversalDirection.up);
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
                        final colNum = isHorizontal ? 7 : 3;
                        if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                          final lastIndex = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                          // 到顶了
                          if(lastIndex<colNum){
                            print('到顶了，焦点转移到 leftBtnScope 区域333');
                            listScope.unfocus();
                            isHorizontal ? leftBtnScope.requestFocus() : topBtnScope.requestFocus();
                          }else{
                            print('up');
                            listScope.focusInDirection(TraversalDirection.up);
                            final index = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                            final int lineNum = (index/colNum).floor(); // 行数
                            // print('焦点元素索引值：-- $index--${listScope.focusedChild}-----$lineNum');
                            listCon.animateTo(lineNum * 283.w, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                          }
                        }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                          print('down');
                          listScope.focusInDirection(TraversalDirection.down);
                          final index = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                          final int lineNum = (index/colNum).floor(); // 行数
                          listCon.animateTo(lineNum * 283.w, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                        }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                          print('left');
                          int i = 1;
                          if(!isHorizontal) i = nodeArr.indexWhere((element) => element == listScope.focusedChild);
                          listScope.focusInDirection(TraversalDirection.left);
                          if(!isHorizontal && i%colNum==0){ // 竖版
                              listScope.unfocus();
                              leftBtnScope.requestFocus();
                          }
                        }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                          print('right33');
                          listScope.focusInDirection(TraversalDirection.right);
                          // listScope.nextFocus();
                        }
                        return KeyEventResult.handled;
                      },
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          width: isHorizontal ? 1232.w : 524.w,
                          // height: isHorizontal ? null : 1034.w,
                          constraints: BoxConstraints(
                            maxHeight: isHorizontal ? (527.w- conObj.padding.top) : 1034.h,
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
                              crossAxisCount: isHorizontal ? 7 : 3, //横轴三个子widget
                              crossAxisSpacing: 21.w, // 横轴间隙
                              mainAxisSpacing: 21.w,
                              childAspectRatio: 146/262,
                            ),
                            children: <Widget>[ ...list ],
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
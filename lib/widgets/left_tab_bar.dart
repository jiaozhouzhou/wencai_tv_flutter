import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../states/index.dart' show Config;
import './wc_button.dart';

class LeftTabBar extends StatefulWidget {
  final ValueChanged<int> onValueChanged;
  final List data;
  final bool isHorizontal;
  final ScrollController scrollController;

  const LeftTabBar({
    super.key,
    required this.data,
    required this.onValueChanged,
    required this.isHorizontal,
    required this.scrollController,
  });

  @override
  State<LeftTabBar> createState() => _LeftTabBar();
}

class _LeftTabBar extends State<LeftTabBar> {
  /*final listDate = [
    {'id': 1, 'name': '本店推荐'},
    {'id': 2, 'name': '我的收藏'},
    {'id': 3, 'name': '热点宣传'},
    {'id': 4, 'name': '足球焦点'},
    {'id': 5, 'name': '篮球焦点'},
    {'id': 6, 'name': '传统足球'},
    {'id': 7, 'name': '体彩走势图'},
    {'id': 8, 'name': '公益之窗'},
    {'id': 9, 'name': '数字彩热点'},
    {'id': 10, 'name': '福彩走势图'},
  ];*/
  int selected = -1;

  void chooseTab(id){
    setState(() {
      selected = id;
    });
    if(id>-1){
      // 将对应模块的列表数据返回给父组件
      widget.onValueChanged(id);
    }
  }

  Widget buildBtn(obj, index){
    final item = obj['category'];
    // final index = item['id'];
    return Focus(
        debugLabel: 'btn$index}',
        autofocus: true,
        onFocusChange: (val){
          if(val){
            chooseTab(index);
            // navBar.jumpTo(132.w);
          }else{
            chooseTab(-1);
          }
        },
        child: selected==index ? WcButton(
          text: item['name'].toString(),
          width: 132.w,
          height: 84.w,
          padding: 0,
          textStyle: TextStyle(fontSize: 24.sp, color: Colors.white),
          startColor: const Color.fromRGBO(254, 103, 58, 1),
          endColor: const Color.fromRGBO(253, 147, 22, 1),
          onPressed: ()=> chooseTab(index),
        ) : WcButton(
          text: item['name'].toString(),
          width: 132.w,
          height: 84.w,
          padding: 0,
          textStyle: TextStyle(fontSize: 24.sp, color: Colors.white),
          backgroundColor: const Color.fromRGBO(4, 8, 89, 1),
          onPressed: ()=> chooseTab(index),
        )
    );
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用navBar.dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final list = widget.data.map(buildBtn);
    final List<Widget> list = [];
    for(var i=0;i<widget.data.length;i++){
      list.add(buildBtn(widget.data[i], i));
    }
    return Consumer<Config>(
      builder: (context, config, child)=> Container(
        width: config.isHorizontal ? 1232.w : 132.w,
        height:  config.isHorizontal ? 84.w : null,
        constraints: BoxConstraints(
          maxHeight: config.isHorizontal ? 84.w : 1034.w, // 设置最大高度
        ),
        color: const Color.fromRGBO(4, 8, 89, 1),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          scrollDirection: config.isHorizontal ? Axis.horizontal : Axis.vertical,
          child: Flex(
            direction:  config.isHorizontal ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: list
          ),
        ),
      )
    );
  }
}
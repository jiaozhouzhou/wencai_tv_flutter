import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../widgets/number_button.dart';
// import 'package:provider/provider.dart';
// import '../states/config.dart';

// This widget is reusable and its buttons are customizable (color, size)
class NumKeyboard extends StatefulWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function? delete;
  final Function onSubmit;
  final FocusScopeNode? focusScopeNode;
  final VoidCallback? backNavFun;

  const NumKeyboard({
    super.key,
    this.buttonSize = 70,
    this.buttonColor = Colors.indigo,
    this.iconColor = Colors.amber,
    this.delete,
    required this.onSubmit,
    required this.controller,
    this.backNavFun,
    this.focusScopeNode,
  });

  @override
  State<NumKeyboard> createState() => _NumKeyboard();
}

class _NumKeyboard extends State<NumKeyboard> {
  final FocusNode deleteBtnNode = FocusNode();
  final FocusNode finishBtnNode = FocusNode();
  late FocusScopeNode kbScopeNode;
  late int? currentNum; // 当前选中的数字按键
  int? currentBtn; // 当前选中的功能按键 0删除  1完成
  final nodeArr = <FocusNode>[];

  void initListFocusNode(){
    for (var i = 0; i < 10; i++) {
      final fn = FocusNode(debugLabel: 'poster$i');
      nodeArr.add(fn);
    }
  }

  void delete(){
    final text = widget.controller.text;
    if(text.isNotEmpty){
      widget.controller.text = text.substring(0, text.length - 1);
    }
  }
  void focusSetCurrentNum(int num){
    setState(() {
      currentNum = num;
      if(currentBtn!=null) currentBtn=null;
    });
  }

  @override
  void initState() {
    initListFocusNode();
    kbScopeNode = widget.focusScopeNode??FocusScopeNode();
    deleteBtnNode.addListener(() {
      if(deleteBtnNode.hasFocus) setState(() {currentBtn = 0;});
    });
    finishBtnNode.addListener(() {
      if(finishBtnNode.hasFocus) setState(() {currentBtn = 1;});
    });
    super.initState();
  }

  @override
  void dispose() {
    for(int i=0; i<nodeArr.length; i++){
      nodeArr[i].dispose();
    }
    kbScopeNode.dispose();
    deleteBtnNode.dispose();
    finishBtnNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final config = context.watch<Config>();
    // final bool isHorizontal = config.isHorizontal;
    return FocusScope(
        node: kbScopeNode,
        autofocus: true,
        debugLabel: 'kbScopeNode',
        onKeyEvent: (focusNode, event) {
          if(!kbScopeNode.hasFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
          // if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
          //   kbScopeNode.focusInDirection(config.correctDirection2(TraversalDirection.up));
          // }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
          //   kbScopeNode.focusInDirection(config.correctDirection2(TraversalDirection.down));
          // }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
          //   kbScopeNode.focusInDirection(config.correctDirection2(TraversalDirection.left));
          // }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
          //   kbScopeNode.focusInDirection(config.correctDirection2(TraversalDirection.right));
          // }
          if(event.logicalKey == LogicalKeyboardKey.select||event.logicalKey == LogicalKeyboardKey.enter){
            if(deleteBtnNode.hasFocus){ // 删除按钮
              delete();
            }else if(finishBtnNode.hasFocus){ // 完成按钮
              widget.onSubmit();
            }else{ // 其他
              widget.controller.text += currentNum.toString();
            }
          }else if(event.logicalKey == LogicalKeyboardKey.arrowUp){
            final lastIndex = nodeArr.indexWhere((element) => element == kbScopeNode.focusedChild);
            if((lastIndex>4&&lastIndex<10)){
              nodeArr[(lastIndex-5).abs()].requestFocus();
            }else if(finishBtnNode.hasFocus){
              deleteBtnNode.requestFocus();
            }
          }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
            final lastIndex = nodeArr.indexWhere((element) => element == kbScopeNode.focusedChild);
            if(lastIndex>-1&&lastIndex<5){
              nodeArr[lastIndex+5].requestFocus();
            }else if(deleteBtnNode.hasFocus){
              finishBtnNode.requestFocus();
            }
          }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            final lastIndex = nodeArr.indexWhere((element) => element == kbScopeNode.focusedChild);
            if(deleteBtnNode.hasFocus){
              nodeArr[4].requestFocus();
            }else if(finishBtnNode.hasFocus){
              nodeArr[9].requestFocus();
            }else if(lastIndex!=5 && lastIndex>0 && lastIndex<10){
              nodeArr[lastIndex-1].requestFocus();
            }
          }else if(event.logicalKey == LogicalKeyboardKey.arrowRight) {
            final lastIndex = nodeArr.indexWhere((element) => element == kbScopeNode.focusedChild);
            if(lastIndex==4){
              deleteBtnNode.requestFocus();
            }else if(lastIndex==9){
              finishBtnNode.requestFocus();
            }else if(lastIndex>-1 && lastIndex<9){
              nodeArr[lastIndex+1].requestFocus();
            }
          }
          return KeyEventResult.handled;
        },
        child: Container(
          // margin: const EdgeInsets.only(left: 0, right: 0),
          height: 238.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.9),
          ),
          child: Column(
            children: [
              // SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // implement the number keys (from 0 to 9) with the NumberButton widget
                // the NumberButton widget is defined in the bottom of this file
                children: [
                  NumberButton(
                    focusNode: nodeArr[0],
                    number: 0,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[1],
                    number: 1,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[2],
                    number: 2,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[3],
                    number: 3,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[4],
                    number: 4,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  IconButton(
                    focusNode: deleteBtnNode,
                    onPressed: delete,
                    icon: Icon(
                      Icons.backspace,
                      color: currentBtn==0 ? widget.iconColor: widget.buttonColor,
                    ),
                    iconSize: widget.buttonSize,
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberButton(
                    focusNode: nodeArr[5],
                    number: 5,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[6],
                    number: 6,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[7],
                    number: 7,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[8],
                    number: 8,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  NumberButton(
                    focusNode: nodeArr[9],
                    number: 9,
                    size: widget.buttonSize,
                    color: widget.buttonColor,
                    controller: widget.controller,
                    focusSetCurrentNum: focusSetCurrentNum,
                  ),
                  IconButton(
                    focusNode: finishBtnNode,
                    onPressed: ()=> widget.onSubmit(),
                    icon: Icon(
                      Icons.done_rounded,
                      color: currentBtn==1 ? widget.iconColor: widget.buttonColor,
                    ),
                    iconSize: widget.buttonSize,
                  ),
                ],
              ),
              // SizedBox(height: 20.w),
            ],
          ),
        )
    );
  }
}
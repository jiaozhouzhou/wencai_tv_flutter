import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' show TDImage,TDText,TDImageType,Font;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class PosterItem extends StatefulWidget {
  final FocusNode? focusNode;
  final Map<String, dynamic> data;


  const PosterItem({
    super.key,
    this.focusNode,
    required this.data,
  });

  @override
  State<PosterItem> createState() => _PosterItemState();
}

class _PosterItemState extends State<PosterItem> {
  bool focused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeFocus(flag){
    setState(() {
      focused = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Focus(
        focusNode: widget.focusNode,
        // autofocus: true,
        onFocusChange: (val){
          changeFocus(val);
        },
        onKeyEvent: (node, event){
          if(event is KeyUpEvent && (event.logicalKey == LogicalKeyboardKey.select||event.logicalKey == LogicalKeyboardKey.enter)){
            Navigator.pushNamed(context, "detail", arguments: data['id']);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: focused ? Colors.yellow : Colors.transparent, width: 2.w),
                      boxShadow: focused ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // 阴影颜色
                          spreadRadius: 5.0, // 阴影扩展半径
                          blurRadius: 10.0, // 阴影模糊半径
                          offset: const Offset(0.0, 0.0), // 阴影偏移量
                        ),
                      ] : null,
                  ),
                  child: TDImage(
                      width: 146.w,
                      height: 225.w,
                      imgUrl: 'http://static.mojing310.com/${data['image']}_s150w',
                      type: TDImageType.stretch,
                      errorWidget: TDText(
                        '加载失败',
                        forceVerticalCenter: true,
                        font: Font(size: 20.sp.toInt(), lineHeight: 1),
                        fontWeight: FontWeight.w500,
                        textColor: const Color.fromRGBO(29, 33, 41, 1),
                      )
                  )
              ),
              SizedBox(height: 10.w),
              Text(
                '这是一段非常长的文本，它可能超出了你希望显示的长度。',
                style: TextStyle(fontSize: 22.sp, color: const Color.fromRGBO(29, 33, 41, 1), height: 1),
                maxLines: 1, // 限制文本只显示一行
                overflow: TextOverflow.ellipsis, // 当文本超出时显示省略号
              ),
              // SizedBox(height: 1.w),
            ],
          ),
    );
  }
}
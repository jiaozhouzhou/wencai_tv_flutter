import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PosterItem extends StatefulWidget {
  final String? imgUrl;
  final FocusNode? focusNode;


  const PosterItem({
    super.key,
    this.imgUrl,
    this.focusNode,
  });

  @override
  State<PosterItem> createState() => _PosterItemState();
}

class _PosterItemState extends State<PosterItem> {
  bool focused = false;

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

    return Focus(
        focusNode: widget.focusNode,
        // autofocus: true,
        onFocusChange: (val){
          changeFocus(val);
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: focused ? Colors.yellow : Colors.transparent, width: 2.w),
                  ),
                  child: TDImage(
                      width: 146.w,
                      height: 225.w,
                      imgUrl: '',
                      type: TDImageType.stretch,
                      errorWidget: TDText(
                        '加载失败',
                        forceVerticalCenter: true,
                        font: TDTheme.of(context).fontBodyExtraSmall,
                        fontWeight: FontWeight.w500,
                        textColor: TDTheme.of(context).fontGyColor3,
                      )
                  )
              ),
              SizedBox(height: 10.w),
              Text(
                '这是一段非常长的文本，它可能超出了你希望显示的长度。',
                style: TextStyle(fontSize: 22.sp, color: const Color.fromRGBO(29, 33, 41, 1), height: 1),
                maxLines: 1, // 限制文本只显示一行
                overflow: TextOverflow.ellipsis, // 当文本超出时显示省略号
              )
            ],
          ),
    );
  }
}
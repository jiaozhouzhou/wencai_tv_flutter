import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './wc_button.dart';

class FocusWcButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const FocusWcButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  State<FocusWcButton> createState() => _FocusWcButton();
}

class _FocusWcButton extends State<FocusWcButton> {
  bool focused = false;

  void changeFocus(flag){
    setState(() {
      focused = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = focused ? Colors.deepOrange.withAlpha(100) : const Color.fromRGBO(13, 17, 122, 1);
    return Focus(
      debugLabel: widget.text,
      // focusNode: FocusNode(),
      autofocus: true,
      onFocusChange: (val){
        changeFocus(val);
      },
      onKeyEvent: (node, event){
        // 按键抬起的时候触发
        if(event is KeyUpEvent && (event.logicalKey == LogicalKeyboardKey.select||event.logicalKey == LogicalKeyboardKey.enter)){
          print('enter333');
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: WcButton(
        text: widget.text,
        icon: widget.icon,
        textStyle: TextStyle(color: Colors.white, fontSize: 21.sp),
        backgroundColor: bgColor,
        borderRadius: BorderRadius.circular(6.w),
        onPressed: widget.onPressed,
      ),
    );
  }
}
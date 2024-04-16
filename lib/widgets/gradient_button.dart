import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color startColor;
  final Color endColor;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final bool disabled;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 200.0,
    this.height = 60.0,
    this.startColor = Colors.red,
    this.endColor = Colors.blue,
    // this.borderRadius = BorderRadius.circular(10.0),
    this.borderRadius = BorderRadius.zero,
    this.textStyle = const TextStyle(color: Colors.white),
    this.disabled = false,
  });

  @override
  State<GradientButton> createState() => _GradientButton();
}

class _GradientButton extends State<GradientButton> {
  bool focused = false;

  void changeFocus(flag){
    setState(() {
      focused = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final material = Focus(
      debugLabel: widget.text,
      // autofocus: true,
      onFocusChange: (val){
        changeFocus(val);
      },
      onKeyEvent: (node, event){
        // 按键抬起的时候触发
        if(event is KeyUpEvent && (event.logicalKey == LogicalKeyboardKey.select||event.logicalKey == LogicalKeyboardKey.enter)){
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Material(
        color: Colors.transparent, // 解决Material白色边框的问题
        elevation: widget.disabled ? 0.0 : 5.0,
        borderRadius: widget.borderRadius,
        // Ink可以实现装饰容器
        child: Ink(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.startColor, widget.endColor],
              ),
              borderRadius: widget.borderRadius,
              border: focused ? Border.all(color: Colors.yellow, width: 2.w) : Border.all(color: Colors.transparent, width: 2.w),
            ),
            child: GestureDetector(
              onTap: widget.disabled ? null: widget.onPressed,
              // borderRadius: widget.borderRadius,
              // customBorder: Border.all(color: Colors.transparent, width: 0.0), // 透明边框避免InkWell的涟漪效果溢出
              child: Center(
                child: Text(
                  widget.text,
                  style: widget.textStyle,
                )
              )
            )
        ),
      ),
    );

    // 如果按钮不可用，在 material 外层包裹一个 Opacity 来改变透明度
    if (widget.disabled) {
      return Opacity(
        opacity: 0.43, // 或者其他合适的透明度值
        child: material,
      );
    }
    return material;
  }
}
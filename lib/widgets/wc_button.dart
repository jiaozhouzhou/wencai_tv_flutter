import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WcButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color startColor;
  final Color endColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final bool disabled;
  final double padding;
  final IconData? icon;
  final dynamic focusNode;

  const WcButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 0,
    this.height = 0,
    this.backgroundColor = Colors.blue,
    this.startColor = Colors.blue,
    this.endColor = Colors.blue,
    this.borderRadius = BorderRadius.zero,
    this.textStyle = const TextStyle(color: Colors.white),
    this.disabled = false,
    this.padding = 10,
    this.icon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    double paddingW = (padding == 10 ? 10.w : padding);
    final iconEvt = (icon!=null) ? [Icon(icon, size: 24.sp, color: Colors.white), SizedBox(width: 3.w)] : [];
    final Material material = Material(
        color: Colors.transparent, // 解决Material白色边框的问题
        borderRadius: borderRadius,
        // Ink可以实现装饰容器
        child: Ink(
            width: width!=0 ? width : null,
            height: height!=0 ? height : 44.w,
            decoration: BoxDecoration(
              // color: backgroundColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: startColor!=Colors.blue ? [startColor, endColor] : [backgroundColor, backgroundColor],
              ),
              borderRadius: borderRadius,
            ),
            // 这里TV版不能使用Inwell,会导致聚焦两次
            child: GestureDetector(
              onTap: disabled ? null: onPressed,
              // focusColor: Colors.deepOrange.withAlpha(80),
              // borderRadius: borderRadius,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: paddingW, right: paddingW),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ...iconEvt,
                    Text(text, style: textStyle),
                  ]
                ),
              ),
            )
        ),
    );

    // 如果按钮不可用，在 material 外层包裹一个 Opacity 来改变透明度
    if (disabled) {
      return Opacity(
        opacity: 0.8, // 或者其他合适的透明度值
        child: material,
      );
    }
    return material;
  }
}
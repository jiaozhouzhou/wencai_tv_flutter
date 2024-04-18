import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInput extends StatefulWidget {
  final double width;
  final double? height;
  final TextInputType inputType;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClearTap;
  final VoidCallback? onEditingComplete;
  final double? fontSize;
  final FocusNode? focusNode;

  const CustomInput({
    super.key,
    required this.width,
    this.height,
    this.fontSize,
    this.focusNode,
    required this.inputType,
    required this.hintText,
    required this.onChanged,
    required this.onClearTap,
    this.onEditingComplete,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late FocusNode inputNode;
  bool focused = false;

  @override
  void initState() {
    super.initState();
    inputNode = widget.focusNode ?? FocusNode();
    inputNode.addListener(() {
      setState(() {
        focused = inputNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    inputNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 58.w,
      height: widget.height,
      child: TDInput(
        // controller: controller[0],
        focusNode: inputNode,
        autofocus: true,
        width: widget.width,
        inputType: widget.inputType,
        showBottomDivider: false,
        textStyle: TextStyle(color: const Color.fromRGBO(29, 33, 41, 1.0), fontSize: widget.fontSize),
        hintText: widget.hintText,
        contentPadding: EdgeInsets.only(top: 8.w, bottom: 8.w, left: 20.w, right: 20.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          border: inputNode.hasFocus ? Border.all(color: Colors.yellow, width: 2.w) : Border.all(color: const Color.fromRGBO(189, 189, 189, 1), width: 2.w),
          borderRadius: BorderRadius.circular(10.w),
        ),
        // inputDecoration: InputDecoration(
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0), // 设置边框圆角
        //     borderSide: BorderSide(color: Colors.blue, width: 2.0), // 设置边框颜色和宽度
        //   ),
        // ),
        onChanged: widget.onChanged,
        onClearTap: widget.onClearTap,
        onEditingComplete: widget.onEditingComplete,
      ),
    );
  }
}
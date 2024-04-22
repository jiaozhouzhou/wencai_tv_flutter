import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberButton extends StatefulWidget {
  final int number;
  final double size;
  final Color color;
  final TextEditingController controller;
  final ValueChanged<int> focusSetCurrentNum;
  final FocusNode? focusNode;

  const NumberButton({
    super.key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
    required this.focusSetCurrentNum,
    this.focusNode,
  });

  @override
  State<NumberButton> createState() => _NumberButton();
}

class _NumberButton extends State<NumberButton>{
  bool focused = false;

  void changeFocus(flag){
    setState(() {
      focused = flag;
      if(flag) widget.focusSetCurrentNum(widget.number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: widget.focusNode,
      style: ElevatedButton.styleFrom(
        // primary: color,
        backgroundColor: focused ? Colors.deepOrange : widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        widget.controller.text += widget.number.toString();
      },
      autofocus: true,
      onFocusChange: changeFocus,
      child: SizedBox(
        width: widget.size,
        height: widget.size/1.5,
        child: Center(
          child: Text(
            widget.number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26.sp),
          ),
        ),
      ),
    );
  }
}
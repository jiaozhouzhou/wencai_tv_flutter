import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/globe.dart';

class BgContainer extends StatelessWidget {
  const BgContainer({
    super.key,
    required this.isHorizontal,
    required this.child,
  });
  final bool isHorizontal;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double width,height;

    if(Global.orientation==Orientation.landscape){
      width = isHorizontal ? 1280.w : 720.w;
      height = isHorizontal ? 720.h : 1280.h;
    }else{
      width = isHorizontal ? 1280.h : 720.w;
      height = isHorizontal ? 720.w : 1280.h;
    }

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isHorizontal ? const AssetImage('assets/img/login_bg2.png') : const AssetImage('assets/img/login_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
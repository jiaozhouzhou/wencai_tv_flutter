import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../widgets/focus_wc_button.dart';
import 'package:provider/provider.dart';
import '../states/config.dart';
import '../common/globe.dart';
import '../common/my_icons.dart';

class HomeHeader extends StatefulWidget {
  final ValueChanged<String> onValueChanged;
  final String data;
  final bool isHorizontal;

  const HomeHeader({
    super.key,
    required this.data,
    required this.onValueChanged,
    required this.isHorizontal,
  });

  @override
  State<HomeHeader> createState() => _HomeHeader();
}

class _HomeHeader extends State<HomeHeader> {

  void handleButtonClick() {
    String newData = '子组件传递的值';
    widget.onValueChanged(newData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<Config>(
      builder: (context, config, child){
        return SizedBox(
          width: config.isHorizontal ? 1232.w : null,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // logo区域
                Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: config.isHorizontal ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: config.isHorizontal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TDImage(
                            width: 46.w,
                            height: 46.w,
                            assetUrl: 'assets/img/logo.png',
                            type: TDImageType.fitWidth,
                          ),
                          SizedBox(width: 4.w),
                          TDImage(
                            width: 78.w,
                            height: 42.w,
                            assetUrl: 'assets/img/wencai.png',
                            type: TDImageType.fitHeight,
                          ),
                        ]
                    ),
                    SizedBox(width: 10.w,height: 6.w),
                    Text('会员截止到2024-07-12', style: TextStyle(color: Colors.white, fontSize: 20.sp))
                  ],
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FocusWcButton(
                        text: '屏幕翻转',
                        icon: MyIcons.screen,
                        onPressed: ()=> config.screenRotate(),
                        // onPressed: ()=> Global.rotatingScreen(MediaQuery.of(context)),
                      ),
                      SizedBox(width: 12.w),
                      FocusWcButton(
                        text: '刷新',
                        icon: MyIcons.refresh,
                        onPressed: (){
                          print('刷新');
                        },
                      ),
                      SizedBox(width: 12.w),
                      FocusWcButton(
                        text: '客服',
                        icon: MyIcons.kf,
                        onPressed: (){
                          print('跳转客服');
                        },
                      ),
                      SizedBox(width: 12.w),
                      FocusWcButton(
                        text: '退出',
                        icon: MyIcons.exit,
                        onPressed: (){
                          Navigator.pushNamed(context, "login");
                          // Navigator.pop(context, "我是返回值")
                        },
                      ),
                    ]
                )
              ]
          )
        );
      }
    );
  }
}
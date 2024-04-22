import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:wencai_tv_flutter/states/index.dart' show Config, User;
import '../widgets/focus_wc_button.dart';
import 'package:provider/provider.dart';
import '../common/my_icons.dart';
import '../utils/helper.dart' show Helper;

class HomeHeader extends StatefulWidget {
  final VoidCallback reFreshFun;
  final String data;
  final bool isHorizontal;

  const HomeHeader({
    super.key,
    required this.data,
    required this.reFreshFun,
    required this.isHorizontal,
  });

  @override
  State<HomeHeader> createState() => _HomeHeader();
}

class _HomeHeader extends State<HomeHeader> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer2<Config,User>(
      builder: (context, config, user, child){
        final tVipExpireTime = Helper.formatTimestamp(user.userinfo['tvip_expire_time']);
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
                    Text('会员截止到$tVipExpireTime', style: TextStyle(color: Colors.white, fontSize: 20.sp))
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
                        onPressed: widget.reFreshFun,
                      ),
                      SizedBox(width: 12.w),
                      FocusWcButton(
                        text: '客服',
                        icon: MyIcons.kf,
                        onPressed: (){
                          debugPrint('跳转客服');
                        },
                      ),
                      SizedBox(width: 12.w),
                      FocusWcButton(
                        text: '退出',
                        icon: MyIcons.exit,
                        onPressed: (){
                          // 退出登录
                          user.setToken('');
                          Navigator.pushReplacementNamed(context, "login");
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
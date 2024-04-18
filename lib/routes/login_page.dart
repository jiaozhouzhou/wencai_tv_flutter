import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:blur/blur.dart';
import '../widgets/gradient_button.dart';
import '../widgets/focus_wc_button.dart';
import '../widgets/bg_container.dart';
import '../widgets/input.dart';
import '../common/my_icons.dart';
import '../utils/request.dart';
import 'package:provider/provider.dart';
import '../states/config.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  // final _formKey = GlobalKey<FormState>();
  final FocusScopeNode formArea = FocusScopeNode();
  final FocusNode codeBtn = FocusNode();
  // final FocusNode verifyCodeIpt= FocusNode();

  void getCode(){
    print('获取验证码');
  }

  void toLogin(){
    print('去登陆');
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  void initState() {
    // TODO: implement initState
    HttpUtil().post("wechat/getLoginQrcode").then((res){
      // 获取数据
      print('res: $res');
    });
    super.initState();
  }

  @override
  void dispose() {
    formArea.dispose();
    // verifyCodeIpt.dispose();
    codeBtn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<Config>();
    final bool isHorizontal = config.isHorizontal;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: BgContainer(
          isHorizontal: isHorizontal,
          child: FocusScope(
            node: formArea,
            autofocus: true,
            debugLabel: 'formArea',
            onKeyEvent: (focusNode, event) {
              // print('-----${event.logicalKey}-----${event.physicalKey}');
              if(!formArea.hasFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
              if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                if(formArea.focusedChild==codeBtn){ // 验证码按钮向上按的时候
                  formArea.children.elementAt(0).requestFocus();
                }else{
                  formArea.focusInDirection(config.correctDirection2(TraversalDirection.up));
                }
              }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                formArea.focusInDirection(config.correctDirection2(TraversalDirection.down));
              }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                formArea.focusInDirection(config.correctDirection2(TraversalDirection.left));
              }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                formArea.focusInDirection(config.correctDirection2(TraversalDirection.right));
              }
              return KeyEventResult.handled;
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(height: isHorizontal ? 0.w : 85.w),
                      TDImage(
                        width: 72.w,
                        height: 72.w,
                        assetUrl: 'assets/img/logo.png',
                        type: TDImageType.fitWidth,
                      ),
                      Padding(
                        padding: isHorizontal ? EdgeInsets.only(top: 10.w, bottom: 0) : EdgeInsets.only(top: 50.w, bottom: 2.w),
                        child: TDText(
                          '登录问彩TV版',
                          style: TextStyle(color: const Color.fromRGBO(63, 63, 63, 1.0), fontWeight: FontWeight.bold, fontSize: isHorizontal ? 36.sp : 48.sp),
                        ),
                      ),
                      TDText(
                        '问彩注册用户才能登录问彩TV版哟～',
                        style: TextStyle(color: const Color.fromRGBO(147, 147, 147, 1.0), fontSize: isHorizontal ? 18.sp : 23.sp, height: 0.8,),
                      ),
                      SizedBox(height: 32.w),
                      CustomInput(
                        // controller: controller[0],
                        width: 514.w,
                        height: isHorizontal ? 48.w : 58.w,
                        inputType: TextInputType.text,
                        fontSize: isHorizontal ? 18.sp : 24.sp,
                        hintText: '请输入您的手机号',
                        onChanged: (text) {
                          print('11111 $text');
                          // setState(() {});
                        },
                        onClearTap: () {
                          // controller[0].clear();
                          setState(() {});
                        },
                        onEditingComplete: (){
                          // formArea.nextFocus();
                          if(formArea.children.elementAt(2).canRequestFocus){
                            formArea.children.elementAt(2).requestFocus();
                          }
                        },
                      ),
                      SizedBox(height: isHorizontal ? 10.w : 28.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomInput(
                            // focusNode: verifyCodeIpt,
                            // controller: controller[0],
                            width: 356.w,
                            height: isHorizontal ? 48.w : 58.w,
                            inputType: TextInputType.number,
                            fontSize: isHorizontal ? 18.sp : 24.sp,
                            hintText: '请输入验证码',
                            onChanged: (text) {
                              setState(() {});
                            },
                            onClearTap: () {
                              // controller[0].clear();
                              setState(() {});
                            },
                            onEditingComplete: (){
                              if(formArea.children.elementAt(3).canRequestFocus){
                                formArea.children.elementAt(3).requestFocus();
                              }
                              // formArea.children.last.requestFocus();
                            },
                          ),
                          SizedBox(width: 15.w),
                          GradientButton(
                            focusNode: codeBtn,
                            text: '53s',
                            width: 146.w,
                            height: isHorizontal ? 48.w : 70.w,
                            disabled: true,
                            textStyle: TextStyle(fontSize: isHorizontal ? 16.sp : 24.sp, color: Colors.white),
                            borderRadius: BorderRadius.circular(8.w),
                            startColor: const Color.fromRGBO(254, 103, 58, 1),
                            endColor: const Color.fromRGBO(253, 147, 22, 1),
                            onPressed: getCode,
                          ),
                        ],
                      ),
                      SizedBox(height: isHorizontal ? 20.w : 40.w),
                      GradientButton(
                        text: '立即登录',
                        width: 374.w,
                        height: isHorizontal ? 48.w :  70.w,
                        textStyle: TextStyle(fontSize: isHorizontal ? 18.sp :  26.sp, color: Colors.white),
                        borderRadius: BorderRadius.circular(8.w),
                        startColor: const Color.fromRGBO(254, 103, 58, 1),
                        endColor: const Color.fromRGBO(253, 147, 22, 1),
                        onPressed: toLogin,
                      ),
                      TDDivider(
                        width: 514.w,
                        text: '微信扫码登录',
                        margin: isHorizontal ? EdgeInsets.only(top: 20.w, bottom: 10.w) : EdgeInsets.only(top: 37.w, bottom: 14.w),
                        color: const Color.fromRGBO(63, 63, 63, 1),
                        alignment: TextAlignment.center,
                      ),
                      TDImage(
                        width: isHorizontal ? 120.w : 150.w,
                        height: isHorizontal ? 120.w : 150.w,
                        imgUrl: '',
                        type: TDImageType.roundedSquare,
                      ),
                    ]
                  ).frosted(
                    width: isHorizontal ? 900.w  : 605.w,
                    height: isHorizontal ? 605.w : 973.w,
                    blur: 10,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  Positioned(
                    top: isHorizontal ? 20.w : 70.w,
                    right: isHorizontal ? 20.w : 24.w,
                    child: FocusWcButton(
                      text: '屏幕翻转',
                      icon: MyIcons.screen,
                      onPressed: ()=> config.screenRotate(),
                    ),
                  ),
                ]
            )
          )
        )
      )
    );
  }
}

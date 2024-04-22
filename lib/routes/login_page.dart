import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:blur/blur.dart';
import '../widgets/gradient_button.dart';
import '../widgets/focus_wc_button.dart';
import '../widgets/bg_container.dart';
import '../widgets/input.dart';
// import '../widgets/num_keyboard.dart';
import '../common/my_icons.dart';
import '../utils/request.dart';
import 'package:provider/provider.dart';
import '../states/index.dart' show Config, User;
import '../utils/helper.dart' show Helper;

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  // final _formKey = GlobalKey<FormState>();
  final FocusScopeNode formArea = FocusScopeNode();
  final FocusNode screenRotateBtn = FocusNode();
  final FocusNode phoneIpt = FocusNode();
  final FocusNode verifyCodeIpt = FocusNode();
  final FocusNode codeBtn = FocusNode();
  final FocusNode loginBtn = FocusNode();
  final TextEditingController phoneNumCtr = TextEditingController();
  final TextEditingController verifyCodeCtr = TextEditingController();
  late TextEditingController kbCurrentCtr;
  String sendCodeText = '发送验证码';
  bool isButtonDisabled = false;
  String qrcode = '';
  String loginId = '';
  Timer? timer;

  void startCountdown() {
    int seconds = 60;
    isButtonDisabled = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
        sendCodeText = '$seconds 秒后重试';
        if (seconds <= 0) {
          timer.cancel();
          sendCodeText = '发送验证码';
          isButtonDisabled = false;
        }
      });
    });
  }

  bool verifyPhone(){
    if(phoneNumCtr.text.isEmpty || phoneNumCtr.text.length<11){
      phoneIpt.requestFocus();
      Helper.showToast('请输入正确手机号码');
      return false;
    }else{
      return true;
    }
  }

  void getCode(){
    // 验证手机号
    if(!verifyPhone()) return;
    // 组合请求数据
    final Map<String, dynamic> data = {
      'mobile': phoneNumCtr.text,
      'scene': 'login',
      'type': 'sms'
    };
    // 请求手机验证码后,开始倒计时
    HttpUtil().post("send/sendSms", data: data).then((res){
      // 获取数据
      debugPrint('res: $res');
      startCountdown();
    });
  }

  void toLogin(BuildContext context){
    // 验证手机号和验证码
    if(!verifyPhone()) return;
    if(verifyCodeCtr.text.isEmpty || verifyCodeCtr.text.length!=4){
      verifyCodeIpt.requestFocus();
      Helper.showToast('请输入正确的验证码');
      return;
    }
    // 组合请求数据
    final Map<String, dynamic> data = {
      'info': [],
      'mobile': phoneNumCtr.text,
      'tv_client_id': '',
      'vcode': verifyCodeCtr.text
    };
    HttpUtil().post("login/index", data: data, loading: true).then((res){
      context.read<User>().setUserInfo(res);
      context.read<User>().setToken(res['access_token']);
      // 登录成功跳转首页
      Navigator.pushReplacementNamed(context, "/");
    }).catchError((res){
      debugPrint('登录接口错误 $res');
    });
  }

  void focusChangeHandle(flag, ctr){
    setState(() {
      if(flag) kbCurrentCtr = ctr;
    });
  }

  @override
  void initState() {
    kbCurrentCtr = phoneNumCtr;
    // TODO: implement initState
    HttpUtil().post("wechat/getLoginQrcode").then((res){
      // 获取数据
      setState(() {
        loginId = res['login_id'];
        qrcode = res['url'];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    formArea.dispose();
    screenRotateBtn.dispose();
    phoneNumCtr.dispose();
    verifyCodeCtr.dispose();
    // phoneIpt.dispose();
    // verifyCodeIpt.dispose();
    codeBtn.dispose();
    loginBtn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<Config>();
    final bool isHorizontal = config.isHorizontal;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // body: SingleChildScrollView(
      body: BgContainer(
          isHorizontal: isHorizontal,
          child: FocusScope(
            node: formArea,
            autofocus: true,
            debugLabel: 'formArea',
            onKeyEvent: (focusNode, event) {
              // print('-----${event.logicalKey}-----${event.physicalKey}');
              if(!formArea.hasFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
              if(event.logicalKey == LogicalKeyboardKey.arrowUp) {
                if(codeBtn.hasFocus){ // 验证码按钮向上按的时候
                  phoneIpt.requestFocus();
                }else{
                  formArea.focusInDirection(config.correctDirection2(TraversalDirection.up));
                }
              }else if(event.logicalKey == LogicalKeyboardKey.arrowDown) {
                if(screenRotateBtn.hasFocus){
                  phoneIpt.requestFocus();
                }else if(phoneIpt.hasFocus){
                  codeBtn.requestFocus();
                }else if(codeBtn.hasFocus||verifyCodeIpt.hasFocus){
                  loginBtn.requestFocus();
                }
              }else if(event.logicalKey == LogicalKeyboardKey.arrowLeft){
                if(!verifyCodeIpt.hasFocus && !phoneIpt.hasFocus){
                  formArea.focusInDirection(config.correctDirection2(TraversalDirection.left));
                }
              }else if(event.logicalKey == LogicalKeyboardKey.arrowRight){
                formArea.focusInDirection(config.correctDirection2(TraversalDirection.right));
              }else if((event.logicalKey==LogicalKeyboardKey.select||event.logicalKey==LogicalKeyboardKey.enter) && (phoneIpt.hasFocus||verifyCodeIpt.hasFocus)) {
                // 打开键盘弹窗
                Helper.openKeyBoard(context, kbCurrentCtr);
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
                        focusNode: phoneIpt,
                        controller: phoneNumCtr,
                        width: 514.w,
                        height: isHorizontal ? 48.w : 58.w,
                        inputType: TextInputType.none,
                        fontSize: isHorizontal ? 18.sp : 24.sp,
                        hintText: '请输入您的手机号',
                        onFocusChange: (flag)=> focusChangeHandle(flag, phoneNumCtr),
                        onChanged: (text) {
                          debugPrint('11111 $text');
                        },
                        onClearTap: () {
                          // controller[0].clear();
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
                            focusNode: verifyCodeIpt,
                            controller: verifyCodeCtr,
                            width: 356.w,
                            height: isHorizontal ? 48.w : 58.w,
                            inputType: TextInputType.none,
                            fontSize: isHorizontal ? 18.sp : 24.sp,
                            hintText: '请输入验证码',
                            onFocusChange: (flag)=> focusChangeHandle(flag, verifyCodeCtr),
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
                            text: sendCodeText,
                            width: 146.w,
                            height: isHorizontal ? 48.w : 70.w,
                            disabled: isButtonDisabled,
                            textStyle: TextStyle(fontSize: isHorizontal ? 16.sp : 24.sp, color: Colors.white),
                            borderRadius: BorderRadius.circular(8.w),
                            startColor: const Color.fromRGBO(254, 103, 58, 1),
                            endColor: const Color.fromRGBO(253, 147, 22, 1),
                            onPressed: isButtonDisabled ? ()=>{} : getCode,
                          ),
                        ],
                      ),
                      SizedBox(height: isHorizontal ? 20.w : 40.w),
                      GradientButton(
                        focusNode: loginBtn,
                        text: '立即登录',
                        width: 374.w,
                        height: isHorizontal ? 48.w :  70.w,
                        textStyle: TextStyle(fontSize: isHorizontal ? 18.sp :  26.sp, color: Colors.white),
                        borderRadius: BorderRadius.circular(8.w),
                        startColor: const Color.fromRGBO(254, 103, 58, 1),
                        endColor: const Color.fromRGBO(253, 147, 22, 1),
                        onPressed: ()=> toLogin(context),
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
                        imgUrl: qrcode,
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
                      focusNode: screenRotateBtn,
                      text: '屏幕翻转',
                      icon: MyIcons.screen,
                      onPressed: ()=> config.screenRotate(),
                    ),
                  ),
                ]
            )
          )
        )
      );
  }
}

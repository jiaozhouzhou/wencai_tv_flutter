import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' show TDImage,TDText,TDImageType,Font;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../states/index.dart' show Poster;
import '../utils/request.dart';
import '../utils/helper.dart' show Helper;
import 'dart:async';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>{
  Timer? _timer ;
  int seconds = 15;
  String url = '';
  bool flag = false;
  int nextPosterId = -1;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 2), () {
    //   // 2秒后执行的代码
    //   Navigator.pushReplacementNamed(context, '/');
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(flag) return;
    // 在这里获取参数并请求接口
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> data = {'template_id': args};
    HttpUtil().get("index/templateDetail", data: data).then((res){
      debugPrint('3333: $res');
      setState(() {
        url = res['image']??'';
        flag = true;
      });
      final posterIdArr = context.read<Poster>().posterIdArr;
      final currentIndex = posterIdArr.indexWhere((element) => element == args);
      final nextPosterIndex = (currentIndex<posterIdArr.length-1) ? (currentIndex+1) : 0;
      nextPosterId = posterIdArr[nextPosterIndex]; // 不让页面更新
      startCountdown();
    });
  }

  @override
  void dispose() {
    if(_timer !.isActive) _timer !.cancel();
    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        if(t.isActive) t.cancel();
        // 获取下一张海报
        // Navigator.popAndPushNamed(context, 'detail', arguments: nextPosterId);
        Navigator.pushReplacementNamed(context, 'detail', arguments: nextPosterId);
      }else{
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final positionText = (_timer==null) ? '按ok键开启自动切换' : '$seconds秒后切换下一张海报，按OK键停止';
    return Focus(
      debugLabel: 'detail_page',
      autofocus: true,
      onKeyEvent: (node, event){
        // 按键抬起的时候触发
        if( event is! KeyDownEvent) return KeyEventResult.ignored;
        if(event.logicalKey == LogicalKeyboardKey.select||event.logicalKey == LogicalKeyboardKey.enter){
          if(_timer!=null){ // 暂停
            _timer!.cancel();
            setState(() {
              _timer = null;
            });
            Helper.showToast('关闭自动轮播海报');
          }else{ // 开启
            startCountdown();
            Helper.showToast('开启自动轮播海报');
          }
          return KeyEventResult.handled;
        }else{
          return KeyEventResult.ignored;
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TDImage(
              imgUrl: 'http://static.mojing310.com/$url',
              type: TDImageType.fitHeight,
              errorWidget: TDText(
                '加载失败',
                forceVerticalCenter: true,
                font: Font(size: 20.sp.toInt(), lineHeight: 1),
                fontWeight: FontWeight.w500,
                textColor: const Color.fromRGBO(29, 33, 41, 1),
              ),
              loadingWidget: TDImage(
                width: 100.w,
                height: 100.w,
                assetUrl: 'assets/img/loading.gif',
                type: TDImageType.fitWidth,
              )
          ),
          // FutureBuilder(
          //   future: enterPage(context),
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     // debugPrint('$snapshot');
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       final url = snapshot.data != null ? snapshot.data['image'] : '';
          //       return TDImage(
          //         imgUrl: 'http://static.mojing310.com/$url',
          //         type: TDImageType.fitHeight,
          //         errorWidget: TDText(
          //           '加载失败',
          //           forceVerticalCenter: true,
          //           font: Font(size: 20.sp.toInt(), lineHeight: 1),
          //           fontWeight: FontWeight.w500,
          //           textColor: const Color.fromRGBO(29, 33, 41, 1),
          //         ),
          //         loadingWidget: TDImage(
          //           width: 100.w,
          //           height: 100.w,
          //           assetUrl: 'assets/img/loading.gif',
          //           type: TDImageType.fitWidth,
          //         ),
          //       );
          //     } else {
          //       // loading
          //       return Container(
          //         decoration: const BoxDecoration(
          //           color: Colors.white,
          //         ),
          //         alignment: Alignment.center,
          //         child: TDImage(
          //           width: 100.w,
          //           height: 100.w,
          //           assetUrl: 'assets/img/loading.gif',
          //           type: TDImageType.fitWidth,
          //         ),
          //       );
          //     }
          //   }
          // ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Text(positionText, style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0))),
              )
          )
        ]
      )
    );
  }
}
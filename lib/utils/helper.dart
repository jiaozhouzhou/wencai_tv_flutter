import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading;
import 'package:tdesign_flutter/tdesign_flutter.dart' show TDSlidePopupRoute,SlideTransitionFrom;
import '../widgets/num_keyboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../common/globe.dart';

double physicalToLogicalPixels(BuildContext context, double physicalPixels) {
  final pixelRatio = MediaQuery
      .of(context)
      .devicePixelRatio;
  return physicalPixels / pixelRatio;
}

double logicalToPhysicalPixels(BuildContext context, double logicalPixels) {
  final pixelRatio = MediaQuery
      .of(context)
      .devicePixelRatio;
  return logicalPixels * pixelRatio;
}

class Helper{

  Future<void> saveToAlbum(pngBytes) async{
    final result = await ImageGallerySaver.saveImage(pngBytes);
    if (result['isSuccess']) {
      debugPrint('保存相册成功');
    } else {
      debugPrint('保存相册失败');
    }
  }

  static void showToast(String str)async {
    EasyLoading.showToast(str);
    /*Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
    );*/
  }

  static String formatTimestamp(int? timestamp) {
    if(timestamp!=null){
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }else{
      return '';
    }
    // return dateTime.toLocal().toString();
  }

  static showLoadingDialog() {
    return EasyLoading.show(status: '加载中...');
    /*final BuildContext? context = Global.materialAppKey.currentContext;
    if(context!=null){
      return showDialog(
        context: context,
        barrierDismissible: false, //点击遮罩不关闭对话框
        builder: (context) {
          return const UnconstrainedBox(
              constrainedAxis: Axis.vertical,
              child: SizedBox(
                width: 280,
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.only(top: 26.0),
                        child: Text("正在加载，请稍后..."),
                      )
                    ],
                  ),
                ),
              )
          );
        },
      );
    }*/
  }
  static hiddeLoadingDialog() {
    return EasyLoading.dismiss();
    // final BuildContext? context = Global.materialAppKey.currentContext;
    // if(context!=null) Navigator.pop(context);
  }

  static openKeyBoard(BuildContext context, kbCurrentCtr) {
    Navigator.of(context).push(TDSlidePopupRoute(
      slideTransitionFrom: SlideTransitionFrom.bottom,
      modalBarrierColor: Colors.transparent,
      builder: (bContext) {
        return NumKeyboard(
          buttonSize: 80.w,
          buttonColor: const Color.fromRGBO(255, 255, 255, 0.3),
          iconColor: Colors.deepOrange,
          controller: kbCurrentCtr,
          onSubmit: () {
            Navigator.pop(bContext);
            // if (phoneIpt.hasFocus) {
            //   codeBtn.requestFocus();
            // }
          }
        );
      }
    ));
  }
}
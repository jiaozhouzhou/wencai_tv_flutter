import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

Future<void> saveToAlbum(pngBytes) async{
  final result = await ImageGallerySaver.saveImage(pngBytes);
  if (result['isSuccess']) {
    print('保存相册成功');
  } else {
    print('保存相册失败');
  }
}
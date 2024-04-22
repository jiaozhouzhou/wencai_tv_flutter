// import 'dart:async';
// import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/helper.dart' show Helper;
import '../common/globe.dart';

class HttpUtil {
  static HttpUtil? instance;
  late Dio dio;
  late BaseOptions options;

  CancelToken cancelToken = CancelToken();

  static getInstance() {
    instance ??= HttpUtil();
    return instance;
  }

  /*
   * config it and create
   */
  HttpUtil() {
    const baseUrl = kDebugMode ? 'http://api2.lotmaster.cn/api/tv.' : 'http://api.lotmaster.cn/api/tv.';
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: baseUrl,
      //连接服务器超时时间，单位是秒.
      connectTimeout: const Duration(seconds: 30),
      //响应流上前后两次接受到数据的间隔，单位为秒。
      receiveTimeout: const Duration(seconds: 5),
      //Http请求头.
      headers: {
        "Content-Type": "application/json",
        "Authorization": "7387028416{|}f8fc6b68cb9badb5aed9b472174485f6",
        // "accesstoken": "",
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      // contentType: Headers.formUrlEncodedContentType,
      contentType: Headers.jsonContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    //Cookie管理 // First request, and save cookies (CookieManager do it). but 好像没生效嘛...
    // final cookieJar = CookieJar();
    // dio.interceptors.add(CookieManager(cookieJar));

    //添加拦截器
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      // 如果获取到token就携带上
      // options.headers.common.accesstoken =
      if(Global.token.isNotEmpty){
        options.headers['accesstoken'] = Global.token;
      }
      // debugPrint("请求之前 header = ${options.headers.toString()}");
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(options); //continue
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      // debugPrint("响应之前：$response");
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(response); // continue
    }, onError: (DioException e, ErrorInterceptorHandler handler) {
      debugPrint("错误之前:$e");
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      return handler.next(e);
    }));
  }

  /*
   * get请求
   */
  get(url, {data, options, cancelToken, bool loading=false}) async {
    if(loading) Helper.showLoadingDialog();
    late Response response;
    try {
      response = await dio.get(url, queryParameters: data, options: options, cancelToken: cancelToken);
      if(loading) Helper.hiddeLoadingDialog();
      // response.data; 响应体
      // response.headers; 响应头
      // response.request; 请求体
      // response.statusCode; 状态码
      return formatCode(response);
    } on DioException catch (e) {
      if(loading) Helper.hiddeLoadingDialog();
      debugPrint('get error---------$e');
      formatError(e);
    }
  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken, bool loading=false}) async {
    if(loading) Helper.showLoadingDialog();
    late Response response;
    try {
      response = await dio.post(url, queryParameters: data, options: options, cancelToken: cancelToken);
      if(loading) Helper.hiddeLoadingDialog();
      return formatCode(response);
    } on DioException catch (e) {
      if(loading) Helper.hiddeLoadingDialog();
      debugPrint('post error---------$e');
      formatError(e);
    }
  }
  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    late Response response;
    try {
      response = await dio.download(urlPath, savePath, onReceiveProgress: (int count, int total) {
        //进度
        debugPrint("$count $total");
      });
      debugPrint('downloadFile success---------${response.data}');
    } on DioException catch (e) {
      debugPrint('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }
  /*
   * code统一处理
   */
  formatCode(response){
    // print('uccess---------${response.statusCode}');
    // print('success---------${response.data}');
    // final res = jsonDecode(response.toString());
    final res = response.data;
    switch (res['code']) {
      case 0: // 正常
        return res['data'];
      case 1:
        if(res['msg']!=null && res['msg'].isNotEmpty){ // 显示错误信息
          Helper.showToast(res['msg']);
        }
        throw(res);
      default:
        break;
    }
  }

  /*
   * error统一处理
   */
  void formatError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      // It occurs when url is opened timeout.
      debugPrint("连接超时");
    } else if (e.type == DioExceptionType.sendTimeout) {
      // It occurs when url is sent timeout.
      debugPrint("请求超时");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      //It occurs when receiving timeout
      debugPrint("响应超时");
    } else if (e.type == DioExceptionType.badResponse) {
      // When the server response, but with a incorrect status, such as 404, 503...
      debugPrint("出现异常");
    } else if (e.type == DioExceptionType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      debugPrint("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      debugPrint("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}


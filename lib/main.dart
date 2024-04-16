import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wencai_tv_flutter/states/config.dart';
import './routes/home_page.dart';
import './routes/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import './common/globe.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
    statusBarIconBrightness: Brightness.light,
  ));
  await ScreenUtil.ensureScreenSize();
  Global.init().then((e) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Config()),
        ],
        child: const MyApp()
      )
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DeviceOrientation direction; // 屏幕方向
    // 屏幕适配初始化
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      // 横版
      ScreenUtil.init(context, designSize: const Size(1280, 720));
      direction = DeviceOrientation.landscapeLeft;
    }else{
      // 竖版
      ScreenUtil.init(context, designSize: const Size(720, 1280));
      direction = DeviceOrientation.portraitUp;
    }
    if(Global.orientation==null) Global.changeOrientation(direction);
    // Provider.of<Config>(context, listen: false).setDeviceOrientation(direction, true);
    /**
      // shortcuts: <LogicalKeySet, Intent>{
      //   LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      // },
    );*/
    return Consumer<Config>(
        builder: (BuildContext context, config, child){
          // 更新全局状态管理内的值
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: "/",
            // 注册路由表
            routes: <String, WidgetBuilder>{
              "/": (context) => const MyHomePage(),
              "login": (context) => const LoginRoute(),
            },
          );
        }
    );
  }
}

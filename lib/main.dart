import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wencai_tv_flutter/states/config.dart';
import './routes/home_page.dart';
import './routes/login_page.dart';
import './routes/waiting_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import './common/globe.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
    statusBarIconBrightness: Brightness.light,
    // systemNavigationBarColor: Colors.transparent,
  ));
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
    final conObj = MediaQuery.of(context);
    return Consumer<Config>(
        builder: (BuildContext context, config, child){
          // 屏幕适配初始化
          if(Global.orientation==null){
            final flag = conObj.orientation==Orientation.landscape;
            ScreenUtil.init(context, designSize: flag ? const Size(1280, 720) : const Size(720, 1280));
            config.setScreen(flag);
            Global.changeOrientation(conObj.orientation);
          }
          // 更新全局状态管理内的值
          return RotatedBox(
            quarterTurns: config.angle,
            child: MaterialApp(
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
                "waiting": (context) => const WaitingPage(),
              },
            )
          );
        }
    );
  }
}

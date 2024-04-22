import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wencai_tv_flutter/states/index.dart' show Config, User, Poster;
import './routes/home_page.dart';
import './routes/login_page.dart';
import './routes/detail_page.dart';
import './routes/waiting_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import './common/globe.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
  //   statusBarIconBrightness: Brightness.light,
  //   // systemNavigationBarColor: Colors.transparent,
  // ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await ScreenUtil.ensureScreenSize();
  Global.init().then((e) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Config()),
          ChangeNotifierProvider(create: (_) => User()),
          ChangeNotifierProvider(create: (_) => Poster()),
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
    final Map<String, WidgetBuilder> routeList = {
      "/": (context) => const MyHomePage(),
      "login": (context) => const LoginRoute(),
      "detail": (context) => const DetailPage(),
      "waiting": (context) => const WaitingPage(),
    };

    return Consumer<Config>(
        builder: (BuildContext context, config, child){
          // 屏幕适配初始化
          if(Global.orientation==null){
            final flag = conObj.orientation==Orientation.landscape;
            ScreenUtil.init(context, designSize: flag ? const Size(1280, 720) : const Size(720, 1280));
            if(Global.rotate['isHorizontal']==null){
              config.setScreen(flag);
            }
            Global.setGlobeInfo(conObj.orientation);
          }
          debugPrint('config：${config.angle}, ${config.isHorizontal}, ${config.orientation}');
          // 更新全局状态管理内的值
          return RotatedBox(
            quarterTurns: config.angle,
            child: MaterialApp(
              key: Global.materialAppKey,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              initialRoute: "/",
              // 注册路由表
              // routes: <String, WidgetBuilder>{
              //   "/": (context) => const MyHomePage(),
              //   "login": (context) => const LoginRoute(),
              //   "detail": (context) => const DetailPage(),
              //   "waiting": (context) => const WaitingPage(),
              // },
              onGenerateRoute: (RouteSettings settings){
                // 实现全局路由守卫
                final user = context.read<User>();
                // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
                var builder = user.isLogin ? routeList[settings.name] : routeList['login'];
                // 确保builder不为null
                builder ??= (content) => const LoginRoute();
                // 构建动态的route
                return MaterialPageRoute(builder: builder, settings: settings);
              },
              builder: EasyLoading.init(),
            )
          );
        }
    );
  }
}

import 'package:flutter/material.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      // 2秒后执行的代码
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('加载中...'),
    );
  }
}
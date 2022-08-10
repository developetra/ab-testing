import 'package:ab_testing/app/page/home_page.dart';
import 'package:ab_testing/utility/layout.dart';
import 'package:flutter/material.dart';

enum ButtonColor { red, blue, green }

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'A/B Testing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xff21022C)),
        builder: (context, child) {
          initLayout(context);
          return const HomePage();
        });
  }
}

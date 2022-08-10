import 'dart:math';

import 'package:ab_testing/utility/layout.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

enum ButtonColor { red, blue, green }

class BasicApp extends StatelessWidget {
  const BasicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A/B Testing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xff21022C)),
      home: FutureBuilder<FirebaseRemoteConfig>(
          future: setupRemoteConfig(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? _HomePage(remoteConfig: snapshot.data!)
                : const Scaffold(body: Text('No data available'));
          }),
    );
  }

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activate();
    await remoteConfig.ensureInitialized();
    return remoteConfig;
  }

  Future<ButtonColor> getLocalTestGroup(int userSeed) async {
    final random = Random(userSeed);
    return ButtonColor.values[random.nextInt(ButtonColor.values.length)];
  }
}

class _HomePage extends StatefulWidget {
  final FirebaseRemoteConfig remoteConfig;

  const _HomePage({Key? key, required this.remoteConfig}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Button color: ${widget.remoteConfig.getString('button_color')}',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: dp(14)),
            ),
          ],
        ),
      ),
    );
  }
}

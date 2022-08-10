import 'package:ab_testing/app/viewmodel/home_model.dart';
import 'package:ab_testing/app/widget/headline.dart';
import 'package:ab_testing/utility/layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeModel _homeModel;

  @override
  void initState() {
    super.initState();
    _homeModel = HomeModel.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: dp(14));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff3C0A87), Color(0xff32044F), Color(0xff21022C), Color(0xff050007)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Headline(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: dp(50), horizontal: dp(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example int: ${_homeModel.exampleValueInt}',
                      style: textStyle,
                    ),
                    Text(
                      'Example bool: ${_homeModel.exampleValueBool}',
                      style: textStyle,
                    ),
                    Text(
                      'Example enum: ${_homeModel.exampleValueEnum}',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: dp(50)),
            ElevatedButton(
              onPressed: () async {
                await _homeModel.fetchNewConfigValues();
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.all(dp(14)),
                child: Text('FETCH CONFIG', style: textStyle),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

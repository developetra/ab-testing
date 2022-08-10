import 'package:ab_testing/utility/layout.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  const Headline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: dp(120), horizontal: dp(50)),
          child: Text(
            'A/B Testing',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: dp(30),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(2.7, 0),
          child: Image.asset(
            'asset/image/dashatar.png',
            width: dp(300),
            height: dp(300),
          ),
        ),
      ],
    );
  }
}

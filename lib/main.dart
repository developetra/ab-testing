import 'package:ab_testing/app/app.dart';
import 'package:ab_testing/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initServices();
  runApp(MultiProvider(
    providers: serviceProviders,
    child: const App(),
    // child: const BasicApp(),
  ));
}

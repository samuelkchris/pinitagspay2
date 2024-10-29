import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pinnitagpay/pages/welcome.dart';
import 'package:pinnitagpay/routes/approutes.dart';
import 'package:pinnitagpay/utils/appprovider.dart';
import 'package:provider/provider.dart';

import 'constant/constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final AppRoutes appRoutes = AppRoutes();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: WelcomePage.route,
      onGenerateRoute: appRoutes.onGenerateRoute,
      home: FlutterSplashScreen(
        duration: const Duration(milliseconds: 6300),
        nextScreen: const WelcomePage(),
        backgroundColor: Colors.white,
        splashScreenBody: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Image.asset(
                    'assets/images/one.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

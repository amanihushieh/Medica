// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medica_app/Screens/Splash_Screen.dart';
import 'package:medica_app/provider/Chat_Service.dart';
import 'package:medica_app/provider/DoctorChat_Service.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDEmixskzIevmrOa4PnVOEiwck5u8BOrh0",
      appId: "1:589497950690:android:df5ea098cd475d54bd99bb",
      messagingSenderId: "589497950690",
      projectId: "medicaapp-8bdb9",
      storageBucket: "medicaapp-8bdb9.appspot.com",
    ),
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: "basic_channel",
          channelName: "basic notification",
          channelDescription: "test"),
    ],
    debug: true,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
         ChangeNotifierProvider(create: (_) => DChatService()),
          ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Nunito',
            ),
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

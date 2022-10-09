import 'package:cocobob_app_flutter/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import './MyWebView.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp()); // initiate MyApp as  StatelessWidget
  FlutterNativeSplash.remove();
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:Future.delayed((Duration(seconds: 3))),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
          }else{
            return MaterialApp(
              title: '펫탈로그',
              home: MyWebView(),
            );
          }
        }
    );

  }
}


import 'package:flutter/material.dart';
import './MyWebView.dart';

void main() => runApp(MyApp()); // initiate MyApp as  StatelessWidget

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '펫탈로그',
      home: MyWebView(),
    );
  }
}


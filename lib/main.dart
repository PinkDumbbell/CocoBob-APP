import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp()); // initiate MyApp as  StatelessWidget

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test SafeArea',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: WebView(
          initialUrl: 'http://192.168.0.6:3000/',
          javascriptMode: JavascriptMode.unrestricted,
        )
      )
    );
  }
}
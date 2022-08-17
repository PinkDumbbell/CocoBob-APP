import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

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


class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final GlobalKey webViewKey = GlobalKey();


  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
     crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading:true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/103.0.5060.63 Mobile/15E148 Safari/604.1'
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
     ios: IOSInAppWebViewOptions(
       allowsInlineMediaPlayback: true
    )
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: InAppWebView(
          key:webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse("http://192.168.0.36:3000/")),
          initialOptions: options,
          androidOnGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async{
            return GeolocationPermissionShowPromptResponse(
                origin:origin,
                allow:true,
                retain:true
            );
          },
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(handlerName: 'platformHandler', callback: (args){
              if(defaultTargetPlatform == TargetPlatform.android) return { 'platform' : 'android' };
              else if(defaultTargetPlatform == TargetPlatform.iOS) return {'platform' : 'ios'};
              else if(defaultTargetPlatform == TargetPlatform.macOS) return {'platform' : 'mac'};
              else if(defaultTargetPlatform == TargetPlatform.windows) return {'platform':'windows'};
              else{
                return {
                  'platform': 'os'
                };
              }
            });
          },

        ),
      ),
    );
  }
}

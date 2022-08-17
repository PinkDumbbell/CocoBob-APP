import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' as foundation;
import "geolocator.dart";

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
  late InAppWebViewController webViewController;
  late String url;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
     crossPlatform: InAppWebViewOptions(
        supportZoom: false,
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

  // getLocationPermission async (){
  //   var currentLocation =  await GeolocatorHandler.determinePosition();
  //   print(currentLocation);
  //   webViewController.evaluateJavascript(source: """
  //     const locatorHandlerEvent = new CustomEvent("locatorListener", window.dispatchEvent(locatorHandlerEvent, ${currentLocation});
  //   """);
  //   return Future(true);
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          body: InAppWebView(
            key:webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse("https://petalog.us")),
            initialOptions: options,
            androidOnGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async{
              return GeolocationPermissionShowPromptResponse(
                  origin:origin,
                  allow:true,
                  retain:true
              );
            },
            onWebViewCreated: (controller) {
              webViewController=controller;
                controller.addJavaScriptHandler(handlerName: 'platformHandler', callback: (args){
                  if(foundation.defaultTargetPlatform == foundation.TargetPlatform.android) {
                    return { 'platform': 'android'};
                  }
                  else if(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS) {
                    return {'platform':'ios'};
                  }
                  else {
                    return {
                      'platform': 'os'
                    };
                   }
                 });
                controller.addJavaScriptHandler(handlerName: 'locationPermissionHandler', callback: (args){
                   // getLocationPermission();
                  var positionJson = GeolocatorHandler.determinePosition();
                  webViewController.evaluateJavascript(source: """
                    const locatorHandlerEvent = new CustomEvent("locatorListener",{positionJson:${positionJson}});
                    window.dispatchEvent(locatorHandlerEvent);
                  """);
                });
              },
            onConsoleMessage: (controller, consoleMessage){
              print('console message: ${consoleMessage.message}');
            },
            ),
          ),
          onWillPop: (){
            var future = webViewController.canGoBack();
            future.then((canGoBack){
              if(canGoBack) {
                webViewController.goBack();
              }
            });

            return Future.value(false);
          },
        ),
      );
  }
}

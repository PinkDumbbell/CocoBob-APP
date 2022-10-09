import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:location/location.dart';

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


  Future<bool> _goBack(BuildContext context) async{
    if(await webViewController.canGoBack()){
      webViewController.goBack();
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  platformHandler(args){
    if(foundation.defaultTargetPlatform == foundation.TargetPlatform.android) {
      return { 'platform': 'android'};
    }
    else if(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS) {
      return { 'platform':'ios' };
    }
    else {
      return { 'platform': 'os' };
    }
  }

  locationPermissionHandler(args) async {
    // getLocationPermission();
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return {
          'success' : false,
          'error': '위치권한 요청에 실패하였습니다.'
        };
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return {
          'success': false,
          'error':'위치권한 사용이 거부되었습니다'
        };
      }
    }

    _locationData = await location.getLocation();
    return {
      'success':true,
      'error':'',
      'location': {
        'latitude':_locationData.latitude,
        'longitude': _locationData.longitude
      }
    };
  }


  locationIntervalHandler(args) async {
    print('location interval handler');
  }

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
              controller.addJavaScriptHandler(handlerName: 'platformHandler', callback: platformHandler);
              controller.addJavaScriptHandler(handlerName: 'locationPermissionHandler', callback: locationPermissionHandler);
              controller.addJavaScriptHandler(handlerName: 'locationIntervalHandler', callback: locationIntervalHandler);
            },
            onConsoleMessage: (controller, consoleMessage){
              print('console message: ${consoleMessage.message}');
            },
          ),
        ),
        onWillPop: ()=>_goBack(context),
      ),
    );
  }
}

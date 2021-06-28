import 'dart:async';
import 'dart:io';

import 'package:app3/util/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';

class WebSite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WebState();
  }
}

class _WebState extends State<WebSite> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
         
          centerTitle: true,
          title: Text('موقع الجامعة'),
        ),
        body: Container(
          height: double.infinity,
          child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: WebView(
                initialUrl: 'http://www.karary.edu.sd/colleges/computer-sciences-and-information-technology/',
                javascriptMode: JavascriptMode.unrestricted,

                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  print("WebView is loading (progress : $progress%)");
                },
                // javascriptChannels: <JavascriptChannel>{
                //   _toasterJavascriptChannel(context),
                // },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              )),
        ),
      )),
    );
  }
}

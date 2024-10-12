import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String webUrl;
  final int eventId, ticketId;
  final bool isNewVisited;
  const WebviewScreen({
    super.key,
    required this.webUrl,
    required this.eventId,
    required this.ticketId,
    required this.isNewVisited,
  });

  @override
  State<StatefulWidget> createState() => _WebviewScreen();
}

class _WebviewScreen extends State<WebviewScreen> {
  late final WebViewController controller;
  dynamic accessToken = '';
  dynamic refreshToken = '';
  static const storage = FlutterSecureStorage();
  bool _isControllerIntialized = false;

  _asyncMethod() async {
    accessToken = await storage.read(key: 'access_token');
    refreshToken = await storage.read(key: 'refresh_token');
  }

  @override
  void initState() {
    super.initState();
    _initializedWebView();
  }

  Future<void> _initializedWebView() async {
    await _asyncMethod();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (value) => {
                controller.runJavaScript(
                    "javascript:initWeb('$accessToken','$refreshToken',${widget.eventId}, ${widget.ticketId}, ${widget.isNewVisited})")
              }))
      ..loadRequest(
        Uri.parse(widget.webUrl),
      );
    setState(() {
      _isControllerIntialized = true;
    });
  }

  Future<bool> onGoBack() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: _isControllerIntialized
          ? WillPopScope(
              onWillPop: () => onGoBack(),
              child: WebViewWidget(controller: controller),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }
}

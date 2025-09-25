import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewModal extends StatefulWidget {
  final String url;

  const WebViewModal({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewModal> createState() => _WebViewModalState();
}

class _WebViewModalState extends State<WebViewModal> {
  InAppWebViewController? webViewController;
  List<Map<String, dynamic>> networkResponses = [];
  bool showNetworkLog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: InAppWebViewSettings(
          useShouldInterceptRequest: true,
          useOnLoadResource: true,
          javaScriptEnabled: true,
          domStorageEnabled: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          print('Started loading: $url');
        },
        onLoadStop: (controller, url) {
          print('Finished loading: $url');
        },
        onReceivedError: (controller, request, error) {
          print('Error: ${error.description}');
        },
        shouldInterceptRequest: (controller, request) async {
          // controller.get
          // Intercept network requests
          // print("request.response");
          // print(request.toJson());
          return null; // Return null to continue with the request
        },
        onLoadResource: (controller, resource) {
          print("resource.response");
          print(resource.toJson());
        },
        onConsoleMessage: (controller, consoleMessage) {
          print("Console: ${consoleMessage.message}");
        },
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      initialSettings: InAppWebViewSettings(
        useShouldInterceptRequest: true,
        useOnLoadResource: true,
        javaScriptEnabled: true,
        domStorageEnabled: true,
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {
        print('Started loading: $url');
      },
      onLoadStop: (controller, url) {
        print('Finished loading: $url');
      },
      onReceivedError: (controller, request, error) {
        print('Error: ${error.description}');
      },
      shouldInterceptRequest: (controller, request) async {
        // controller.get
        // Intercept network requests
        print("request.response");
        print(request.toJson());
        return null; // Return null to continue with the request
      },
      onLoadResource: (controller, resource) {
        print("resource.response");
        print(resource.toJson());
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("Console: ${consoleMessage.message}");
      },
    );
  }
}

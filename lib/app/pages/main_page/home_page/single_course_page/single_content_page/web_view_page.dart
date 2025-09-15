import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../../common/components.dart';
import '../../../../../../common/data/app_language.dart';
import '../../../../../../common/utils/constants.dart';
import '../../../../../../locator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
   static const String pageName = '/web-view';
  @override
  _VideoWebViewState createState() => _VideoWebViewState();
}

class _VideoWebViewState extends State<WebViewPage> {
  late InAppWebViewController _webViewController;
  late PullToRefreshController _pullToRefreshController;
  late InAppWebViewGroupOptions options;

  @override
  void initState() {
    super.initState();
    options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,  // Allow autoplay
       // allowsInlineMediaPlayback: true,  // Enable inline playback for videos
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true, // Use hybrid composition for better performance
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,  // Enable inline playback for iOS
      ),
    );

    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        await _webViewController.reload();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(title: ""),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
            "https://iframe.mediadelivery.net/embed/86578/90fb375c-4aee-476e-8028-f100f83eaead?autoplay=false&loop=false&muted=false&preload=true&responsive=true",
          ),
        ),
        initialOptions: options,
        pullToRefreshController: _pullToRefreshController,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onProgressChanged: (controller, progress) {
          if (progress == 100) {
            _pullToRefreshController.endRefreshing();
          }
        },
        onLoadStart: (controller, url) {
          print("WebView started loading: $url");
        },
        onLoadStop: (controller, url) async {
          print("WebView finished loading: $url");
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
        onReceivedError: (controller, request, error) {
          print("Error occurred: $error");
        },
      ),
    );
  }
}

// class WebViewPage extends StatefulWidget {
//   static const String pageName = '/web-view';
//   const WebViewPage({super.key});
//
//   @override
//   State<WebViewPage> createState() => _WebViewPageState();
// }
//
// class _WebViewPageState extends State<WebViewPage> {
//   final GlobalKey webViewKey = GlobalKey();
//   InAppWebViewController? webViewController;
//
//   InAppWebViewSettings settings = InAppWebViewSettings(
//     mediaPlaybackRequiresUserGesture: false,
//     allowsInlineMediaPlayback: true,
//     iframeAllow: "camera; microphone",
//     iframeAllowFullscreen: true,
//     mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//     cacheEnabled: true,
//     javaScriptEnabled: true,
//     useHybridComposition: true,
//     sharedCookiesEnabled: true,
//     useShouldOverrideUrlLoading: true,
//     useOnLoadResource: false,
//     forceDark: ForceDark.ON,
//     preferredContentMode: UserPreferredContentMode.MOBILE,
//   );
//
//   CookieManager cookieManager = CookieManager.instance();
//   String? url;
//   String? title;
//   bool isShow = false;
//   bool isSendTokenInHeader = true;
//   LoadRequestMethod method = LoadRequestMethod.post;
//   String token = '';
//
//   @override
//   void initState() {
//     super.initState();
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final args = ModalRoute.of(context)?.settings.arguments as List?;
//       if (args != null) {
//         url = args[0];
//         title = args[1] ?? '';
//         isSendTokenInHeader = args.length > 2 ? args[2] ?? true : true;
//         method = args.length > 3 ? args[3] ?? LoadRequestMethod.post : LoadRequestMethod.post;
//
//         final iframeRegex = RegExp(r'src="([^"]+)"');
//         final match = iframeRegex.firstMatch(url ?? '');
//         if (match != null) {
//           url = match.group(1);
//         }
//       }
//
//       token = await AppData.getAccessToken();
//
//       if (token.isNotEmpty && url != null) {
//         final domain = Constants.dommain.replaceAll('https://', '');
//
//         cookieManager.setCookie(
//           url: WebUri(url!),
//           name: 'XSRF-TOKEN',
//           value: token,
//           domain: domain,
//           isHttpOnly: true,
//           isSecure: true,
//           path: '/',
//           expiresDate: DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch,
//         );
//
//         cookieManager.setCookie(
//           url: WebUri(url!),
//           name: 'webinar_session',
//           value: token,
//           domain: domain,
//           isHttpOnly: true,
//           isSecure: true,
//           path: '/',
//           expiresDate: DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch,
//           sameSite: HTTPCookieSameSitePolicy.LAX,
//         );
//       }
//
//       isShow = true;
//       setState(() {});
//       await [Permission.camera, Permission.microphone].request();
//     });
//   }
//
//   Future<void> load() async {
//     final header = {
//       if (isSendTokenInHeader) "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//       "x-api-key": Constants.apiKey,
//       "x-locale": locator<AppLanguage>().currentLanguage.toLowerCase(),
//     };
//
//     if (!(url?.startsWith('http') ?? false)) {
//       await webViewController?.loadData(data: url ?? '', baseUrl: null, historyUrl: null);
//     } else {
//       await webViewController?.loadUrl(
//         urlRequest: URLRequest(
//           method: method == LoadRequestMethod.post ? "POST" : "GET",
//           url: WebUri(url ?? ''),
//           headers: header,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isShow
//           ? Container(
//         color: Colors.white,
//         height: MediaQuery.of(context).size.height,
//         child: InAppWebView(
//           key: webViewKey,
//           initialSettings: settings,
//           onWebViewCreated: (controller) async {
//             webViewController = controller;
//             load();
//           },
//           onPermissionRequest: (controller, request) async {
//             return PermissionResponse(
//               resources: request.resources,
//               action: PermissionResponseAction.GRANT,
//             );
//           },
//           onProgressChanged: (controller, progress) {
//             setState(() {});
//           },
//           onLoadStop: (controller, url) async {
//             await controller.evaluateJavascript(source: """
//                     document.body.style.margin = '0';
//                     document.body.style.padding = '0';
//                     document.documentElement.style.margin = '0';
//                     document.documentElement.style.padding = '0';
//
//                     var meta = document.createElement('meta');
//                     meta.name = 'viewport';
//                     meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
//                     document.getElementsByTagName('head')[0].appendChild(meta);
//
//                     var videos = document.getElementsByTagName('video');
//                     for (var i = 0; i < videos.length; i++) {
//                       videos[i].style.width = '100vw';
//                       videos[i].style.height = 'auto';
//                       videos[i].style.maxWidth = '100%';
//                       videos[i].style.objectFit = 'contain';
//                       videos[i].controls = true;
//                     }
//
//                     var iframes = document.getElementsByTagName('iframe');
//                     for (var i = 0; i < iframes.length; i++) {
//                       iframes[i].style.width = '100vw';
//                       iframes[i].style.height = '56.25vw';
//                       iframes[i].style.maxWidth = '100%';
//                       iframes[i].style.border = 'none';
//                     }
//
//                     var divs = document.getElementsByTagName('div');
//                     for (var i = 0; i < divs.length; i++) {
//                       divs[i].style.width = '100vw';
//                       divs[i].style.maxWidth = '100%';
//                       divs[i].style.overflow = 'hidden';
//                     }
//                   """);
//           },
//           onReceivedServerTrustAuthRequest: (controller, challenge) async {
//             final allowedHosts = [
//               "googlevideo.com",
//               "jnn-pa.googleapis.com",
//               "play.google.com",
//               "iframe.mediadelivery.net", // ✅ Add trusted iframe domain here
//             ];
//             final host = challenge.protectionSpace.host;
//
//             if (allowedHosts.any((trustedHost) => host.contains(trustedHost))) {
//               return ServerTrustAuthResponse(
//                 action: ServerTrustAuthResponseAction.PROCEED,
//               );
//             } else {
//               return ServerTrustAuthResponse(
//                 action: ServerTrustAuthResponseAction.CANCEL,
//               );
//             }
//           },
//         ),
//       )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     webViewController?.dispose();
//     super.dispose();
//   }
// }

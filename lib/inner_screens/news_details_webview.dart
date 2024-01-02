import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/utils.dart';
import '../widgets/vertical_spacing.dart';

class NewsDetailsWebview extends StatefulWidget {
  const NewsDetailsWebview({super.key});

  @override
  State<NewsDetailsWebview> createState() => _NewsDetailsWebviewState();
}

class _NewsDetailsWebviewState extends State<NewsDetailsWebview> {
  // final WebViewController controller = WebViewController();
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          // _progress = progress / 100;
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'https://www.google.com/search?sca_esv=595131700&sxsrf=AM9HkKlimAvWkPHOKb9cSK85lG5uP8CkZA:1704217615075&q=Aconcagua&stick=H4sIAAAAAAAAAONgFmLXz9U3yEpPUeIEMQzTTc3LtRSzk630c_KTE0sy8_PgDKvEkpKixGQQs3gRK6djcn5ecmJ6aSIAwmgtuUUAAAA&sa=X&ved=2ahUKEwjR28Osob-DAxWE8wIHHbqrDhAQ2coHegQILhAB&biw=1280&bih=598&dpr=1.5'));
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          // stay inside
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            iconTheme: IconThemeData(color: color),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'url', // widget.url,
              style: TextStyle(color: color),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await _showModalSheetFct();
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ]),
        body: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showModalSheetFct() async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VerticalSpacing(20),
                Center(
                  child: Container(
                    height: 5,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const VerticalSpacing(20),
                const Text(
                  'More option',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const VerticalSpacing(20),
                const Divider(
                  thickness: 2,
                ),
                const VerticalSpacing(20),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () async {
                    try {
                      await Share.share('widget.url',
                          subject: 'Look what I made!');
                    } catch (err) {
                      // GlobalMethods.errorDialog(
                      //     errorMessage: err.toString(), context: context);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: const Text('Open in browser'),
                  onTap: () async {
                    if (!await launchUrl(Uri.parse('widget.ur'))) {
                      throw 'Could not launch ${'widget.url'}}';
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () async {
                    try {
                      await controller.reload();
                    } catch (err) {
                      log("error occured $err");
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}

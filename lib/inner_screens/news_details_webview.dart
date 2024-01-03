import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/vertical_spacing.dart';

class NewsDetailsWebview extends StatefulWidget {
  final String url;
  const NewsDetailsWebview({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<NewsDetailsWebview> createState() => _NewsDetailsWebviewState();
}

class _NewsDetailsWebviewState extends State<NewsDetailsWebview> {
  // final WebViewController controller = WebViewController();
  var loadingPercentage = 0;
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

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
              widget.url,
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
              child: Stack(
                children: [
                  WebViewWidget(
                    controller: controller,
                  ),
                  if (loadingPercentage < 100)
                    LinearProgressIndicator(
                      value: loadingPercentage / 100.0,
                    ),
                ],
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
                      // ignore: use_build_context_synchronously
                      GlobalMethods.errorDialog(
                          errorMessage: err.toString(), context: context);
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

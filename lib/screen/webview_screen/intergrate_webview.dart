import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:starting_block/constants/constants.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String id;

  const WebViewScreen({
    Key? key,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller), // WebView 위젯
          Positioned(
            // 오버레이 될 버튼
            top: 16,
            left: 20,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: AppColors.black.withOpacity(0.5),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image(image: AppImages.back_white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

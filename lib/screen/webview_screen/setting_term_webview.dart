import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:starting_block/constants/constants.dart';

class SettingTermWebview extends StatelessWidget {
  final String url;

  const SettingTermWebview({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)), // 여기를 수정합니다
      ),
    );
  }
}

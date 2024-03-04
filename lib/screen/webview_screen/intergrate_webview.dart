import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:starting_block/constants/constants.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String id;
  final String classification;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.id,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)), // 여기를 수정합니다
            // 필요한 경우 추가 InAppWebView 설정을 여기에 추가할 수 있습니다.
          ),
          const Positioned(
            bottom: 0,
            child: BottomGradient(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 48,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * (72 / 360),
                    height: 48,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 1,
                            color: AppColors.bluelight,
                          ),
                        ),
                        child: Center(
                          child: AppIcon.back_web,
                        ),
                      ),
                    ),
                  ),
                ),
                WebBookMarkButton(id: id, classification: classification)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingOpenSourceNotice extends StatelessWidget {
  const SettingOpenSourceNotice({super.key});

  void _showLicensePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => const LicensePage(
        applicationName: 'Your App Name',
        applicationVersion: '1.0.0',
        applicationLegalese: '© 2024 Your Company Name',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오픈소스 라이선스'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showLicensePage,
          child: const Text('라이선스 보기'), // 버튼이 눌리면 라이선스 페이지를 보여주는 함수 호출
        ),
      ),
    );
  }
}

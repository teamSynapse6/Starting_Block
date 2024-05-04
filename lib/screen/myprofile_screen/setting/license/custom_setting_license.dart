import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/myprofile_screen/setting/license/oss_licenses.dart';

class CustomLicensePage extends StatefulWidget {
  const CustomLicensePage({super.key});

  @override
  State<CustomLicensePage> createState() => _CustomLicensePageState();
}

class _CustomLicensePageState extends State<CustomLicensePage> {
  List<Package> packages = ossLicenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackTitleAppBarForLicense(
        title: '오픈소스 라이선스',
      ),
      body: ListView.builder(
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          return ListTile(
            title: Text(package.name),
            subtitle: Text('Version ${package.version}'),
            onTap: () {
              // 세부 정보 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LicenseDetailPage(package: package),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LicenseDetailPage extends StatelessWidget {
  final Package package;

  const LicenseDetailPage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTitleAppBarForLicense(title: package.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Version: ${package.version}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "License:\n${package.license}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

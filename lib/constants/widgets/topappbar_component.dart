// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/recentsearch_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    Key? key,
    required this.newAlarm,
  }) : super(key: key);

  final bool newAlarm;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 12,
      ),
      child: AppBar(
        leading: Transform.scale(
          scale: 0.625,
          alignment: Alignment.centerLeft,
          child: Image(image: AppImages.topapplogo),
        ),
        actions: <Widget>[
          SizedBox(
            height: 48,
            width: 48,
            child: Image(
              image: !newAlarm
                  ? AppImages.notification_inactived
                  : AppImages.notification_actived,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 12,
      ),
      child: AppBar(
        actions: <Widget>[
          SizedBox(
            height: 48,
            width: 48,
            child: Image(image: AppImages.settings),
          ),
        ],
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final searchTapScreen;

  const SearchAppBar({
    Key? key,
    required this.searchTapScreen,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 12,
      ),
      child: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => searchTapScreen),
              );
            },
            child: SizedBox(
              height: 48,
              width: 48,
              child: Image(image: AppImages.search),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchFiledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onBackTap;
  final RecentSearchManager recentSearchManager;

  const SearchFiledAppBar({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onBackTap,
    required this.recentSearchManager, // RecentSearchManager 인스턴스 추가
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  void _onSearchSubmitted(BuildContext context, String query) async {
    // 검색 내역을 추가하고 결과 화면으로 이동하는 로직
    await recentSearchManager.addSearch(query);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OffCampusSearchResult(searchWord: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: onBackTap,
        child: Image(image: AppImages.back),
      ),
      titleSpacing: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (query) => _onSearchSubmitted(context, query),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bd2.copyWith(color: AppColors.g3),
                contentPadding: EdgeInsets.zero,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image(image: AppImages.back),
      ),
    );
  }
}

class CloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CloseAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 12,
      ),
      child: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              height: 48,
              width: 48,
              child: Image(image: AppImages.close24),
            ),
          ),
        ],
      ),
    );
  }
}

class SaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SaveAppBar({
    Key? key,
    required this.thisBookMark, // 이 부분을 Widget으로 변경
  }) : super(key: key);

  final Widget thisBookMark; // 이 부분을 Widget으로 변경

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 12,
      ),
      child: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image(image: AppImages.back),
        ),
        actions: <Widget>[
          SizedBox(
            height: 48,
            width: 48,
            child: thisBookMark, // 이 부분에서 위젯을 사용
          ),
        ],
      ),
    );
  }
}

class BackTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackTitleAppBar({
    Key? key,
    this.thisTextStyle,
    required this.text,
    this.onPress,
  }) : super(key: key);

  final thisTextStyle;
  final String text;
  final onPress;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image(image: AppImages.back),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextButton(
            onPressed: () {
              onPress;
            },
            child: Text(text, style: thisTextStyle),
          ),
        ),
      ],
    );
  }
}

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleAppBar({
    Key? key,
    required this.thisTextStyle,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  final thisTextStyle;
  final String text;
  final onPress;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextButton(
            onPressed: () {
              onPress;
            },
            child: Text(text, style: thisTextStyle),
          ),
        ),
      ],
    );
  }
}

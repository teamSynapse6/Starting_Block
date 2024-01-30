// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/recentsearch_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.newAlarm,
  });

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
          child: AppIcon.topapplogo,
        ),
        actions: <Widget>[
          SizedBox(
            height: 48,
            width: 48,
            child: !newAlarm
                ? AppIcon.notification_inactived
                : AppIcon.notification_actived,
          ),
        ],
      ),
    );
  }
}

class SettingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingAppBar({super.key});

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
            child: AppIcon.settings,
          ),
        ],
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final searchTapScreen, thisBackGroundColor;

  const SearchAppBar({
    super.key,
    required this.searchTapScreen,
    this.thisBackGroundColor,
  });

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
        backgroundColor: thisBackGroundColor ?? AppColors.white,
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
              child: AppIcon.search,
            ),
          ),
        ],
      ),
    );
  }
}

class OnCampusSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final searchTapScreen, thisBackGroundColor;

  const OnCampusSearchAppBar({
    super.key,
    required this.searchTapScreen,
    this.thisBackGroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: thisBackGroundColor ?? AppColors.white,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => searchTapScreen),
              );
            },
            child: SizedBox(
              height: 48,
              width: 48,
              child: AppIcon.search,
            ),
          ),
        ),
      ],
    );
  }
}

class SearchFiledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onBackTap;
  final RecentSearchManager recentSearchManager;

  const SearchFiledAppBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onBackTap,
    required this.recentSearchManager, // RecentSearchManager 인스턴스 추가
  });

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
        child: AppIcon.back,
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
  final state, thisBgColor;

  const BackAppBar({
    super.key,
    this.state,
    this.thisBgColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: thisBgColor ?? AppColors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context, state);
        },
        child: AppIcon.back,
      ),
    );
  }
}

class CloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final state;

  const CloseAppBar({
    super.key,
    this.state,
  });

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
              Navigator.pop(context, state);
            },
            child: SizedBox(
              height: 48,
              width: 48,
              child: AppIcon.close24,
            ),
          ),
        ],
      ),
    );
  }
}

class SaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SaveAppBar({
    super.key,
    required this.thisBookMark, // 이 부분을 Widget으로 변경
  });

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
          child: AppIcon.back,
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
    super.key,
    this.thisTextStyle,
    required this.text,
    this.onPress,
  });

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
        child: AppIcon.back,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: onPress,
            child: SizedBox(
              width: 73,
              height: 32,
              child: Center(
                child: Text(
                  text,
                  style: thisTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleAppBar({
    super.key,
    required this.thisTextStyle,
    required this.text,
    required this.onPress,
  });

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

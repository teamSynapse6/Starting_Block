// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/recentsearch_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
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
        backgroundColor: AppColors.g1,
        leadingWidth: 38,
        leading: AppIcon.topapplogo,
        actions: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeAlarmScreen(),
                ),
              );
            },
            child: SizedBox(
              height: 48,
              width: 48,
              child: !newAlarm
                  ? AppIcon.notification_inactived
                  : AppIcon.notification_actived,
            ),
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
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyProfileGptList(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: AppIcon.gpt_robot_24,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingHome(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: AppIcon.settings,
                ),
              ),
            ],
          ),
        ),
      ],
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
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(left: 4),
          child: AppIcon.back,
        ),
      ),
      titleSpacing: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
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

class SearchResultAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onBackTap, onCloseTap;
  final RecentSearchManager recentSearchManager;

  const SearchResultAppBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onBackTap,
    required this.recentSearchManager,
    required this.onCloseTap, // RecentSearchManager 인스턴스 추가
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
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(left: 4),
          child: AppIcon.back,
        ),
      ),
      titleSpacing: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
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
      actions: [
        GestureDetector(
          onTap: onCloseTap,
          child: Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: 12),
            child: AppIcon.close24,
          ),
        ),
      ],
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
        toolbarHeight: 56, // Set the height of the AppBar to 56
      ),
    );
  }
}

class BackTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final thisTextStyle;
  final String text;
  final thisOnTap;
  final state;

  const BackTitleAppBar({
    super.key,
    this.thisTextStyle,
    required this.text,
    this.thisOnTap,
    this.state,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context, state);
        },
        child: AppIcon.back,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: thisOnTap,
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

class BackTitleAppBarForGptList extends StatelessWidget
    implements PreferredSizeWidget {
  const BackTitleAppBarForGptList({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: AppIcon.back_white,
      ),
      titleSpacing: 4,
      title: Text(
        'AI로 공고 분석하기',
        style: AppTextStyles.st1.copyWith(color: AppColors.white),
      ),
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

class TermAppBar extends StatelessWidget implements PreferredSizeWidget {
  final state, thisBgColor;

  const TermAppBar({
    super.key,
    this.state,
    this.thisBgColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(128);

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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 24),
            child: Text(
              '개인정보처리방침 및 이용약관',
              style: AppTextStyles.st1.copyWith(color: AppColors.g6),
            ),
          ),
        ),
      ),
    );
  }
}

class BackTitleAppBarForLicense extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const BackTitleAppBarForLicense({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 4),
          width: 48,
          height: 48,
          child: AppIcon.back,
        ),
      ),
      titleSpacing: 4,
      title: Text(
        title,
        style: AppTextStyles.st2.copyWith(color: AppColors.g6),
      ),
    );
  }
}

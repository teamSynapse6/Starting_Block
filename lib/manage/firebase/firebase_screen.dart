import 'package:flutter/widgets.dart';

class FirebaseScreenInfo {
  final String id;
  final String koreanName;
  final String className;
  final String group;
  final bool trackEnabled;

  const FirebaseScreenInfo({
    required this.id,
    required this.koreanName,
    required this.className,
    required this.group,
    this.trackEnabled = true,
  });
}

class FirebaseScreens {
  static const splash = FirebaseScreenInfo(
    id: 'splash',
    koreanName: '스플래시 화면',
    className: 'SplashScreen',
    group: 'app',
  );

  static const onboardingLogin = FirebaseScreenInfo(
    id: 'onboarding_login',
    koreanName: '로그인 화면',
    className: 'LoginScreen',
    group: 'onboarding',
  );

  static const offcampusHome = FirebaseScreenInfo(
    id: 'offcampus_home',
    koreanName: '교외 지원 홈 화면',
    className: 'OffCampusHome',
    group: 'offcampus',
  );

  static const oncampusHome = FirebaseScreenInfo(
    id: 'oncampus_home',
    koreanName: '교내 지원 홈 화면',
    className: 'OnCampusHome',
    group: 'oncampus',
  );

  static const oncampusSchoolSet = FirebaseScreenInfo(
    id: 'oncampus_school_set',
    koreanName: '교내 학교 미설정 화면',
    className: 'OnCampusSchoolSet',
    group: 'oncampus',
  );

  static const homeMain = FirebaseScreenInfo(
    id: 'home_main',
    koreanName: '홈 메인 화면',
    className: 'HomeScreen',
    group: 'home',
  );

  static const roadmapHome = FirebaseScreenInfo(
    id: 'roadmap_home',
    koreanName: '로드맵 홈 화면',
    className: 'RoadmapHome',
    group: 'roadmap',
  );

  static const roadmapSet = FirebaseScreenInfo(
    id: 'roadmap_set',
    koreanName: '로드맵 설정 화면',
    className: 'RoadMapSet',
    group: 'roadmap',
  );

  static const myprofileHome = FirebaseScreenInfo(
    id: 'myprofile_home',
    koreanName: '마이페이지 홈 화면',
    className: 'MyProfileHome',
    group: 'myprofile',
  );

  static const intergrate = FirebaseScreenInfo(
    id: 'intergrate',
    koreanName: '통합 탭 컨테이너',
    className: 'IntergrateScreen',
    group: 'container',
    trackEnabled: false,
  );

  static final Map<String, FirebaseScreenInfo> _byClassName = {
    for (final screen in knownScreens) screen.className: screen,
  };

  static final Map<String, FirebaseScreenInfo> _byId = {
    for (final screen in knownScreens) screen.id: screen,
  };

  static const List<FirebaseScreenInfo> knownScreens = [
    splash,
    onboardingLogin,
    offcampusHome,
    oncampusHome,
    oncampusSchoolSet,
    homeMain,
    roadmapHome,
    roadmapSet,
    myprofileHome,
    intergrate,
    FirebaseScreenInfo(
      id: 'onboarding_nickname',
      koreanName: '온보딩 닉네임 화면',
      className: 'NickNameScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_birthday',
      koreanName: '온보딩 생일 화면',
      className: 'BirthdayScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_entrepreneur',
      koreanName: '온보딩 사업자 형태 화면',
      className: 'EnterprenutScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_residence',
      koreanName: '온보딩 거주지 화면',
      className: 'ResidenceScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_school',
      koreanName: '온보딩 학교 화면',
      className: 'SchoolScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_roadmap_set',
      koreanName: '온보딩 로드맵 설정 화면',
      className: 'RoadmapScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_roadmap_add',
      koreanName: '온보딩 로드맵 추가 화면',
      className: 'RoadmapScreenAdd',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_roadmap_delete',
      koreanName: '온보딩 로드맵 삭제 화면',
      className: 'RoadmapScreenDelete',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'onboarding_complete',
      koreanName: '온보딩 완료 화면',
      className: 'CompleteScreen',
      group: 'onboarding',
    ),
    FirebaseScreenInfo(
      id: 'offcampus_detail',
      koreanName: '교외 지원 상세 화면',
      className: 'OffCampusDetail',
      group: 'offcampus',
    ),
    FirebaseScreenInfo(
      id: 'offcampus_search',
      koreanName: '교외 지원 검색 화면',
      className: 'OffCampusSearch',
      group: 'offcampus',
    ),
    FirebaseScreenInfo(
      id: 'offcampus_search_result',
      koreanName: '교외 지원 검색 결과 화면',
      className: 'OffCampusSearchResult',
      group: 'offcampus',
    ),
    FirebaseScreenInfo(
      id: 'offcampus_webview',
      koreanName: '교외 지원 웹뷰 화면',
      className: 'OffCampusWebViewScreen',
      group: 'webview',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_notify',
      koreanName: '교내 지원 공고 화면',
      className: 'OnCampusNotify',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_system',
      koreanName: '교내 창업 제도 화면',
      className: 'OnCampusSystem',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_class',
      koreanName: '교내 창업 강의 화면',
      className: 'OnCampusClass',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_supportgroup',
      koreanName: '교내 창업지원단 화면',
      className: 'OnCampusSupportGroup',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_search',
      koreanName: '교내 검색 화면',
      className: 'OnCampusSearch',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_search_result',
      koreanName: '교내 검색 결과 화면',
      className: 'OnCampusSearchResult',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_school_search',
      koreanName: '교내 학교 검색 화면',
      className: 'OnCampusSchoolSearch',
      group: 'oncampus',
    ),
    FirebaseScreenInfo(
      id: 'oncampus_webview',
      koreanName: '교내 지원 웹뷰 화면',
      className: 'OncampusWebViewScreen',
      group: 'webview',
    ),
    FirebaseScreenInfo(
      id: 'question_home',
      koreanName: '질문 홈 화면',
      className: 'QuestionHome',
      group: 'question',
    ),
    FirebaseScreenInfo(
      id: 'question_write',
      koreanName: '질문 작성 화면',
      className: 'QuestionWrite',
      group: 'question',
    ),
    FirebaseScreenInfo(
      id: 'question_detail',
      koreanName: '질문 상세 화면',
      className: 'QuestionDetail',
      group: 'question',
    ),
    FirebaseScreenInfo(
      id: 'question_write_complete',
      koreanName: '질문 작성 완료 화면',
      className: 'QuestionWriteComplete',
      group: 'question',
    ),
    FirebaseScreenInfo(
      id: 'llm_chat',
      koreanName: 'LLM 채팅 화면',
      className: 'LlmChatScreen',
      group: 'llm',
    ),
    FirebaseScreenInfo(
      id: 'myprofile_llm_list',
      koreanName: '마이페이지 LLM 리스트 화면',
      className: 'MyProfileLlmList',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_home',
      koreanName: '프로필 수정 홈 화면',
      className: 'ProfileEditHome',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_school',
      koreanName: '프로필 학교 수정 화면',
      className: 'SchoolNameEdit',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_nickname',
      koreanName: '프로필 닉네임 수정 화면',
      className: 'NickNameEdit',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_birthday',
      koreanName: '프로필 생일 수정 화면',
      className: 'BirthdayEdit',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_residence',
      koreanName: '프로필 거주지 수정 화면',
      className: 'ResidenceEdit',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_entrepreneur',
      koreanName: '프로필 사업자 형태 수정 화면',
      className: 'EnterprenutEdit',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'profile_edit_icon',
      koreanName: '프로필 아이콘 수정 화면',
      className: 'ProfileIconEdit',
      group: 'myprofile',
    ),
    FirebaseScreenInfo(
      id: 'setting_home',
      koreanName: '설정 홈 화면',
      className: 'SettingHome',
      group: 'setting',
    ),
    FirebaseScreenInfo(
      id: 'setting_alarm',
      koreanName: '설정 알람 화면',
      className: 'AlarmSetting',
      group: 'setting',
    ),
    FirebaseScreenInfo(
      id: 'setting_llm_model',
      koreanName: '설정 온디바이스 AI 모델 화면',
      className: 'SettingLlmModel',
      group: 'setting',
    ),
    FirebaseScreenInfo(
      id: 'setting_license',
      koreanName: '설정 오픈소스 라이선스 화면',
      className: 'CustomLicensePage',
      group: 'setting',
    ),
    FirebaseScreenInfo(
      id: 'setting_license_detail',
      koreanName: '설정 라이선스 상세 화면',
      className: 'LicenseDetailPage',
      group: 'setting',
    ),
    FirebaseScreenInfo(
      id: 'setting_term_webview',
      koreanName: '약관 웹뷰 화면',
      className: 'SettingTermWebview',
      group: 'webview',
    ),
  ];

  static FirebaseScreenInfo? byId(String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    return _byId[id];
  }

  static FirebaseScreenInfo? byClassName(String? className) {
    if (className == null || className.isEmpty) {
      return null;
    }
    return _byClassName[className];
  }

  static FirebaseScreenInfo? fromWidget(Widget widget) {
    final screen = byClassName(widget.runtimeType.toString());
    if (screen != null) {
      return screen.trackEnabled ? screen : null;
    }
    return FirebaseScreenInfo(
      id: _toSnakeCase(widget.runtimeType.toString()),
      koreanName: widget.runtimeType.toString(),
      className: widget.runtimeType.toString(),
      group: 'unmapped',
    );
  }

  static String _toSnakeCase(String value) {
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      final char = value[i];
      final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;
      if (isUpper && i > 0) {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    }
    return buffer.toString();
  }
}

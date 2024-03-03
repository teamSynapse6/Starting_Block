// constants.dart
export 'package:starting_block/constants/gaps.dart';
export 'package:starting_block/constants/sizes.dart';
export 'package:starting_block/constants/font_table.dart';
export 'package:starting_block/constants/color_table.dart';
export 'package:starting_block/constants/icon_table.dart';

// 컴포넌트 관리
export 'package:starting_block/constants/widgets/topappbar_component.dart'; //탑앱바
export 'package:starting_block/constants/widgets/contained_button.dart'; //contained버튼
export 'package:starting_block/constants/widgets/itemlist_component.dart'; //지원사업공고 리스트
export 'package:starting_block/constants/widgets/organize_chip.dart'; //기관명 칩
export 'package:starting_block/constants/widgets/divider_component.dart'; //디바이더
export 'package:starting_block/constants/widgets/detailpage_containedbutton.dart'; //공고 상세페이지의 버튼
export 'package:starting_block/constants/widgets/inputchips_component.dart'; //인풋칩버튼
export 'package:starting_block/constants/widgets/dialog_component.dart'; //다이얼로그(alert창) 컴포넌트
export 'package:starting_block/constants/widgets/bookmark/bookmark_button.dart'; //로드맵에 저장 버튼
export 'package:starting_block/constants/widgets/reorder_list.dart'; //로드맵 순서 변경 리스트
export 'package:starting_block/constants/widgets/bottom_gradiant.dart'; //하단 투명 Gradient
export 'package:starting_block/constants/widgets/ofca_sorting_textbuttonsheet.dart'; //정렬_(최신순, 저장순)정렬 설정
export 'package:starting_block/constants/widgets/onboarding_state.dart'; //온보딩 화면 상단 현재 단계
export 'package:starting_block/constants/widgets/setting_widget/setting_list.dart'; //설정_리스트 위젯
export 'package:starting_block/constants/widgets/setting_widget/profile_icon_list.dart'; //설정_프로필 수정 리스트 위젯
export 'package:starting_block/constants/widgets/question_widget/question_list.dart'; //질문 홈_리스트 위젯

//교외지원사업 바텀시트
export 'package:starting_block/constants/widgets/offcampus_filter/enterpreneurchipsheet.dart'; //사업자 형태 리스트 및 칩스 컴포넌트
export 'package:starting_block/constants/widgets/offcampus_filter/residencechipsheet.dart'; //지역 리스트 및 칩스 컴포넌트
export 'package:starting_block/constants/widgets/offcampus_filter/supportchipsheet.dart'; //지원유형 리스트 및 칩스 컴포넌트
export 'package:starting_block/constants/widgets/offcampus_filter/bottomsheet_list.dart'; //bottomsheet 리스트 컴포넌트_교내지원사업과 함께 공유됨

//교외지원사업 바텀시트
export 'package:starting_block/constants/widgets/oncampus_filter/onca_programchipsheet.dart'; //교내지원사업_프로그램 컴포넌트
export 'package:starting_block/constants/widgets/oncampus_filter/onca_resetbutton.dart'; //교내지원사업 필터 리셋 위젯

//리스트 필터 시스템
export 'package:starting_block/constants/widgets/offcampus_filter/intergrate_filter.dart'; //교외지원사업_통합 필터 시스템
export 'package:starting_block/constants/widgets/oncampus_filter/onca_intergrate_filter.dart'; //교내지원사업_통합 필터 시스템

//홈 컴포넌트 관리
export 'package:starting_block/constants/widgets/home_widget/question_stepper.dart'; //질문 단계 스텝퍼 위젯
export 'package:starting_block/constants/widgets/home_widget/dash_stroke.dart'; //질문 단계_dash 위젯
export 'package:starting_block/constants/widgets/home_widget/notify_recommend_list.dart'; //공고 추천 위젯
export 'package:starting_block/constants/widgets/home_widget/question_recommend_list.dart'; //질문 추천 위젯
export 'package:starting_block/constants/widgets/home_widget/ofca_onca_chip.dart'; //교내교외 구분 칩

//로드맵 컴포넌트 관리
export 'package:starting_block/screen/roadmap_screen/widget/roadmap_gotosave.dart'; //로드맵_지원사업 저장하러 가기
export 'package:starting_block/screen/roadmap_screen/widget/roadmap_stepnotify.dart'; //단계 알리미
export 'package:starting_block/screen/roadmap_screen/widget/roadmap_nextstep.dart'; // 다음 단계 도약
export 'package:starting_block/screen/roadmap_screen/widget/roadmap_backtostep.dart'; // 현 단계로 돌아가기
export 'package:starting_block/screen/roadmap_screen/widget/roadmap_sliverappbar.dart'; //SliverAppBar 관리
export 'package:starting_block/screen/roadmap_screen/tabscreen/offcampus_biz/ofca_card.dart'; //로드맵_교외사업의 카드
export 'package:starting_block/screen/roadmap_screen/tabscreen/offcampus_biz/ofca_list.dart'; //로드맵_교외사업의 리스트
export 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_notify/onca_notify_list.dart'; //로드맵_교외사업의 리스트
export 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_class/onca_class_list.dart'; //로드맵_창업강의의 리스트
export 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_system/onca_system_list.dart'; //로드맵_창업제도의 리스트

//교내지원사업 컴포넌트 관리
export 'package:starting_block/screen/on_campus_screen/widget/oncampus_home_card_large.dart'; //교내지원사업_Home_Large카드
export 'package:starting_block/screen/on_campus_screen/widget/oncampus_home_card_medium.dart'; //교내지원사업_Home_Medium카드
export 'package:starting_block/screen/on_campus_screen/widget/oncampus_home_card_smallsys.dart'; //교내지원사업_Home_Small 제도 카드
export 'package:starting_block/screen/on_campus_screen/widget/oncampus_home_card_smallclass.dart'; //교내지원사업_Home_Small 강의 카드
export 'package:starting_block/constants/widgets/oncampus_listcard/oncampus_system_listcard.dart'; //교내지원사업_교내제도 리스트 카드
export 'package:starting_block/constants/widgets/oncampus_listcard/oncampus_class_chips.dart'; //교내지원사업_교내 강의 chips
export 'package:starting_block/constants/widgets/oncampus_listcard/oncampuss_class_listcard.dart'; //교내지원사업_교내 강의 리스트 카드
export 'package:starting_block/constants/widgets/oncampus_listcard/oncampus_notify_listcard.dart'; //교내지원사업_지원공고 리스트 카드
export 'package:starting_block/constants/widgets/oncampus_listcard/oncampus_supportgroup_list.dart'; //교내지원사업_창업지원단 통합 리스트 카드
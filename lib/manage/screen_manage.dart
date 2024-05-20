//Screen파일 관리용
//온보딩 페이지
export 'package:starting_block/main.dart';
export 'package:starting_block/screen/onboarding_screen/login_0_2.dart';
export 'package:starting_block/manage/save_fetch_userdata.dart'; //유저 데이터 가져오기
export 'package:starting_block/screen/onboarding_screen/nickname_0_4.dart';
export 'package:starting_block/screen/onboarding_screen/birthday_0_5.dart';
export 'package:starting_block/screen/onboarding_screen/entrepreneur_0_6.dart';
export 'package:starting_block/screen/onboarding_screen/residence_0_7.dart';
export 'package:starting_block/screen/onboarding_screen/school_0_8.dart';
export 'package:starting_block/screen/onboarding_screen/roadmapset_0_9.dart';
export 'package:starting_block/screen/onboarding_screen/roadmapset_0_9_1_add.dart';
export 'package:starting_block/screen/onboarding_screen/roadmapset_0_9_2_delete.dart';
export 'package:starting_block/screen/onboarding_screen/complete_10.dart';

//전체 공통 관리용(GNB)
export 'package:starting_block/screen/intergrate_screen.dart';
export 'package:starting_block/constants/widgets/bottom_navigation/gnb_tap.dart';

//교외지원사업 페이지
export 'package:starting_block/screen/off_campus_screen/offcampus_home.dart';
export 'package:starting_block/screen/off_campus_screen/offcampus_detail.dart';
export 'package:starting_block/screen/off_campus_screen/offcampus_detail_info.dart';
export 'package:starting_block/screen/off_campus_screen/offcampus_detail_gpt_card.dart';
export 'package:starting_block/screen/off_campus_screen/offcampus_recommendation.dart';
export 'package:starting_block/screen/off_campus_screen/offcampus_search.dart';
export 'package:starting_block/screen/off_campus_screen/offcampus_searchresult.dart';

//GPT 채팅 페이지
export 'package:starting_block/screen/gpt_chat/offcampus_gpt_chat.dart';
export 'package:starting_block/screen/gpt_chat/myprofile_gpt_chat.dart';

//로드맵 페이지
export 'package:starting_block/screen/roadmap_screen/roadmap_home.dart';
export 'package:starting_block/screen/roadmap_screen/roadmaplist_edit.dart';
export 'package:starting_block/screen/roadmap_screen/roadmaplist_add.dart';
export 'package:starting_block/screen/roadmap_screen/roadmap_delet.dart';
export 'package:starting_block/screen/roadmap_screen/widget/roadmap_list.dart'; //로드맵 단계 리스트 뷰 버튼
export 'package:starting_block/manage/roadmap_list.dart'; //추천 가능한 리스트

//로드맵 탭 화면
export 'package:starting_block/screen/roadmap_screen/tabscreen/offcampus_biz/offcampus_business_tab.dart';
export 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_notify/oncampus_notify_tab.dart';
export 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_class/oncampus_class_tab.dart';
export 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_system/oncampus_system_tab.dart';
//로드맵 미설정 시 설정화면
export 'package:starting_block/screen/roadmap_screen/roadmap_nonset_screen/roadmap_set.dart';
export 'package:starting_block/screen/roadmap_screen/roadmap_nonset_screen/roadmap_list_set.dart';
export 'package:starting_block/screen/roadmap_screen/roadmap_nonset_screen/roadmap_list_add.dart';
export 'package:starting_block/screen/roadmap_screen/roadmap_nonset_screen/roadmap_list_delete.dart';
export 'package:starting_block/screen/roadmap_screen/roadmap_nonset_screen/roadmap_first_popup.dart'; //로드맵 설정 첫 팝업 화면
//로드맵 도약시 화면
export 'package:starting_block/screen/roadmap_screen/roadmap_leap_screen/leap_first.dart'; //첫 도약시 팝업 화면
export 'package:starting_block/screen/roadmap_screen/roadmap_leap_screen/leap_after_first.dart'; //두번째부터 도약시 팝업 화면

//교내지원사업 페이지
export 'package:starting_block/screen/on_campus_screen/oncampus_home.dart';
export 'package:starting_block/screen/on_campus_screen/oncampus_system.dart'; //교내창업제도화면
export 'package:starting_block/screen/on_campus_screen/oncampus_class.dart'; //교내창업강의화면
export 'package:starting_block/screen/on_campus_screen/oncampus_notify.dart'; //교내지원공고화면
export 'package:starting_block/screen/on_campus_screen/oncampus_supportgroup.dart'; //교내창업지원단 화면
export 'package:starting_block/screen/on_campus_screen/oncampus_search.dart'; //교내 검색 화면
export 'package:starting_block/screen/on_campus_screen/oncampus_searchresult.dart'; //교내 검색 화면
export 'package:starting_block/screen/on_campus_screen/school_nonset_screen/oncampus_school_set.dart'; //학교 설정없을 시 화면
export 'package:starting_block/screen/on_campus_screen/school_nonset_screen/oncampus_school_search.dart'; //학교 설정없을 학교 설정 화면

//교내지원사업_창업지원단_페이지
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/metoring.dart'; //멘토링 화면
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/club.dart'; //동아리 화면
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/competition.dart'; //경진대회 화면
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/camp.dart'; //캠프 화면
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/lecture.dart'; //동아리 화면
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/space.dart'; //공가 화면
export 'package:starting_block/screen/on_campus_screen/supportgroup_tab_screen/etc.dart'; //기타 화면

//마이프로필 페이지
export 'package:starting_block/screen/myprofile_screen/myprofile_home.dart'; //마이페이지 홈 화면
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_home.dart'; //프로필 수정_홈 화면
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_school.dart'; //프로필 수정_학교 변경 화면
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_nickname.dart'; //프로필 수정_닉네임 변경 화면
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_birthday.dart'; //프로필 수정_생일 변경 화면
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_residence.dart'; //프로필 수정_거주지 변경 화면
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_enterpreneur.dart'; //프로필 수정_사업자 형태 수정
export 'package:starting_block/screen/myprofile_screen/profile_edit/profile_edit_profileicon.dart'; //프로필 수정_프로필 아이콘 수정
export 'package:starting_block/screen/myprofile_screen/setting/setting_home.dart'; //설정_홈 화면
export 'package:starting_block/screen/myprofile_screen/setting/setting_alarm.dart'; //설정_알람 화면
export 'package:starting_block/screen/myprofile_screen/setting/license/custom_setting_license.dart'; //설정_오픈소스 라이센스 화면
export 'package:starting_block/screen/myprofile_screen/tabscreen/myprofile_my_heart.dart'; //탭_내 궁금해요
export 'package:starting_block/screen/myprofile_screen/tabscreen/myprofile_my_answer_reply.dart'; //탭_내 댓글,답글
export 'package:starting_block/screen/myprofile_screen/tabscreen/myprofile_my_question.dart'; //탭_내 질문
export 'package:starting_block/screen/myprofile_screen/myprofile_gpt_list.dart'; //AI로 공고 분석하기 리스트 화면

//홈_페이지
export 'package:starting_block/screen/home_screen/home_screen.dart'; //홈 메인 화면
export 'package:starting_block/screen/home_screen/home_question_step.dart'; //홈_질문 단계
export 'package:starting_block/screen/home_screen/home_question_step_expend.dart'; //홈_질문 단계 확장 영역
export 'package:starting_block/screen/home_screen/home_question_screen/home_question_step_1.dart'; //홈_질문 단계 상세_1단계(질문접수) 화면
export 'package:starting_block/screen/home_screen/home_question_screen/home_question_step_2.dart'; //홈_질문 단계 상세_2단계(질문발송) 화면
export 'package:starting_block/screen/home_screen/home_question_screen/home_question_step_3.dart'; //홈_질문 단계 상세_3단계(답변도착) 화면
export 'package:starting_block/screen/home_screen/home_notify_recommend.dart'; //홈_공고 추천 영역
export 'package:starting_block/screen/home_screen/home_question_recommend.dart'; //홈_질문 추천 영역

//인앱웹뷰 페이지 관리용
export 'package:starting_block/screen/webview_screen/offcampus_webview.dart'; //교외지원사업 웹뷰
export 'package:starting_block/screen/webview_screen/oncampus_webview.dart'; //교내지원사업 웹뷰
export 'package:starting_block/screen/webview_screen/setting_term_webview.dart'; //개인정보처리방침 및 이용약관 웹뷰

//질문하기 페이지
export 'package:starting_block/screen/question_screen/question_home.dart'; //질문_홈 화면
export 'package:starting_block/screen/question_screen/question_write.dart'; //질문 작성 화면
export 'package:starting_block/screen/question_screen/question_detail.dart'; //질문 상세 화면
export 'package:starting_block/screen/question_screen/question_detail_info.dart'; //질문 상세 화면_질문영역
export 'package:starting_block/screen/question_screen/comment_screen/user_comment.dart'; //유저 댓글 영역
export 'package:starting_block/screen/question_screen/comment_screen/reply_comment.dart'; //유저 답글 영역
export 'package:starting_block/screen/question_screen/comment_screen/contact_reply_comment.dart'; //문의처 답글 영역
export 'package:starting_block/screen/question_screen/question_write_complete.dart'; //질문 작성 완료 화면

//데이터 파일 관리용
export 'package:starting_block/screen/onboarding_screen/onboarding_data/school_info.dart';

//설정 데이터 파일 관리용
export 'package:starting_block/manage/theme_manage.dart';

//스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/offcampus_home_skeleton.dart'; //교외지원사업 홈, 검색 화면 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/oncampus_skeleton/onca_notify_skeleton.dart'; //교내지원사업_공고 화면 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/oncampus_skeleton/onca_system_skeleton.dart'; //교내지원사업_제도 화면 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/oncampus_skeleton/onca_class_skeleton.dart'; //교내지원사업_강의 화면 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/oncampus_skeleton/onca_supportgroup_skeleton.dart'; //교내지원사업_창업지원단 화면 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/oncampus_skeleton/onca_search_skeleton.dart'; //교내지원사업_검색 화면 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/home_skeleton/home_notift_rec_skeleton.dart'; //홈_공고 추천 영역 스켈레톤 로더 화면
export 'package:starting_block/skeleton_screen/roadmap_skeleton/roadmap_tap_ofca_onca_skeleton.dart'; //로드맵_교외사업 탭 스켈레톤 로더 화면


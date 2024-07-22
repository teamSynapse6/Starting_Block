class QuestionListModel {
  final int questionId;
  final String content;
  final int heartCount;
  final int answerCount;
  final bool isHaveContactAnswer;
  final bool isMyHeart;
  final int heartId; // 이 부분이 수정되었습니다.

  QuestionListModel.fromJson(Map<String, dynamic> json)
      : questionId = json['questionId'] as int? ?? 0, // 타입 캐스팅에 기본값 추가
        content = json['content'] as String? ?? '', // 타입 캐스팅에 기본값 추가
        heartCount = json['heartCount'] as int? ?? 0, // 타입 캐스팅에 기본값 추가
        answerCount = json['answerCount'] as int? ?? 0, // 타입 캐스팅에 기본값 추가
        isHaveContactAnswer =
            json['isHaveContactAnswer'] as bool? ?? false, // 타입 캐스팅에 기본값 추가
        isMyHeart = json['isMyHeart'] as bool? ?? false, // 타입 캐스팅에 기본값 추가
        heartId = json['heartId'] as int? ?? 0; // 타입 캐스팅에 기본값 추가
}

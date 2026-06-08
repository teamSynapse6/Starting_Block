class LlmChatStageText {
  const LlmChatStageText._();

  static String statusMessage(String stage) {
    switch (stage) {
      case 'dynamic_slot_acquired':
        return '스타터가 질문을 상세히 살펴보고 있어요';
      case 'dynamic_queue_waiting':
        return '스타터가 답변 순서를 기다리고 있어요';
      case 'queue_waiting':
        return '스타터가 답변 순서를 기다리고 있어요';
      case 'gpu_waiting':
        return '스타터가 도구를 준비하고 있어요';
      case 'request_received':
        return '스타터가 질문을 확인하고 있어요';
      case 'storage_preparing':
        return '스타터가 공고 저장소를 준비하고 있어요';
      case 'vector_index_preparing':
        return '스타터가 검색 인덱스를 준비하고 있어요';
      case 'session_loaded':
        return '스타터가 이전 대화를 불러오고 있어요';
      case 'history_optimized':
        return '스타터가 이전 대화를 정리하고 있어요';
      case 'retrieval_started':
        return '스타터가 공고에서 관련 내용을 찾고 있어요';
      case 'rag_searched':
      case 'rag_context_prepared':
        return '스타터가 찾은 공고 내용을 정리하고 있어요';
      case 'fallback_context_loading':
        return '스타터가 공고 원문을 다시 확인하고 있어요';
      case 'fallback_context_loaded':
        return '스타터가 참고할 공고 내용을 찾았어요';
      case 'retrieval_completed':
        return '스타터가 온디바이스 AI에게 넘길 내용을 준비했어요';
      case 'llm_model_ready':
        return '스타터가 기기의 AI 모델을 준비하고 있어요';
      case 'llm_generating':
        return '스타터가 기기에서 답변을 만들고 있어요';
      case 'llm_thinking':
        return '스타터가 답변을 생각하고 있어요';
      case 'llm_response_generated':
        return '스타터가 답변을 마무리하고 있어요';
      case 'session_saved':
        return '스타터가 답변을 저장하고 있어요';
      case 'stream_waiting':
        return '스타터가 이어받을 답변을 기다리고 있어요';
      case 'cancelled':
        return '답변 생성이 중단됐어요';
      default:
        return '스타터가 답변을 준비하고 있어요';
    }
  }

  static bool isQueueStage(String stage) {
    return stage == 'dynamic_queue_waiting' ||
        stage == 'queue_waiting' ||
        stage == 'gpu_waiting' ||
        stage == 'stream_waiting';
  }

  static bool isFinishedStage(String stage) {
    return stage == 'cancelled' || stage == 'session_saved';
  }
}

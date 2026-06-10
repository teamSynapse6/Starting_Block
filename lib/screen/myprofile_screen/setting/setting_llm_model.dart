import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';
import 'package:starting_block/manage/llm/apple_intelligence_llm_manage.dart';
import 'package:starting_block/manage/llm/on_device_llm_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class SettingLlmModel extends StatefulWidget {
  const SettingLlmModel({super.key});

  @override
  State<SettingLlmModel> createState() => _SettingLlmModelState();
}

class _SettingLlmModelState extends State<SettingLlmModel> {
  final Map<String, LlmModelDownloadSnapshot> _downloadSnapshots = {};
  final Set<String> _deletingModels = {};
  StreamSubscription<LlmModelDownloadSnapshot>? _downloadSubscription;

  List<LlmModelInfo> _models = [];
  Set<String> _installedModelIds = {};
  AppleIntelligenceAvailability? _appleAvailability;
  bool _isAppleAvailabilityLoading = false;
  bool _isLoading = true;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _downloadSubscription = OnDeviceLlmManage.downloadEvents.listen((snapshot) {
      if (!mounted) {
        return;
      }
      setState(() {
        _downloadSnapshots[snapshot.modelName] = snapshot;
      });
      if (snapshot.progress >= 100 && !snapshot.isDownloading) {
        unawaited(_refreshInstalledModels());
      }
      if (snapshot.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snapshot.errorMessage)),
        );
      }
    });
    unawaited(_loadModels());
    unawaited(_loadAppleAvailability());
  }

  @override
  void dispose() {
    _downloadSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadModels() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorText = '';
      });
    }

    try {
      final models = await LlmApi.getLlmModelList();
      final snapshots = <String, LlmModelDownloadSnapshot>{};
      for (final model in models) {
        snapshots[OnDeviceLlmManage.localModelName(model)] =
            await OnDeviceLlmManage.getDownloadSnapshot(model);
      }
      final installedModels = await OnDeviceLlmManage.getInstalledModelNames();
      if (!mounted) {
        return;
      }
      setState(() {
        _models = models;
        _installedModelIds = installedModels.toSet();
        _downloadSnapshots
          ..clear()
          ..addAll(snapshots);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorText = '모델 목록을 불러오지 못했습니다.';
      });
    }
  }

  Future<void> _loadAppleAvailability() async {
    if (!Platform.isIOS) {
      return;
    }

    if (mounted) {
      setState(() {
        _isAppleAvailabilityLoading = true;
      });
    }

    final availability = await AppleIntelligenceLlmManage.checkAvailability();
    if (!mounted) {
      return;
    }
    setState(() {
      _appleAvailability = availability;
      _isAppleAvailabilityLoading = false;
    });
  }

  Future<void> _downloadModel(LlmModelInfo model) async {
    final modelName = OnDeviceLlmManage.localModelName(model);
    if (_downloadSnapshots[modelName]?.isDownloading == true) {
      return;
    }

    final initialSnapshot = await OnDeviceLlmManage.getDownloadSnapshot(model);
    if (!mounted) {
      return;
    }
    setState(() {
      _downloadSnapshots[modelName] = LlmModelDownloadSnapshot(
        modelName: modelName,
        progress: initialSnapshot.progress,
        downloadedChunks: initialSnapshot.downloadedChunks,
        totalChunks: initialSnapshot.totalChunks,
        isDownloading: true,
      );
    });

    unawaited(OnDeviceLlmManage.downloadModel(model).then((_) async {
      await _refreshInstalledModels();
    }).catchError((_) {}));
  }

  Future<void> _refreshInstalledModels() async {
    final installedModels = await OnDeviceLlmManage.getInstalledModelNames();
    if (!mounted) {
      return;
    }
    setState(() {
      _installedModelIds = installedModels.toSet();
    });
  }

  Future<void> _deleteModel(LlmModelInfo model) async {
    final modelName = OnDeviceLlmManage.localModelName(model);
    if (_deletingModels.contains(modelName)) {
      return;
    }

    setState(() {
      _deletingModels.add(modelName);
    });

    try {
      await OnDeviceLlmManage.deleteModel(modelName);
      await _loadModels();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모델 삭제에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _deletingModels.remove(modelName);
        });
      }
    }
  }

  void _showDeleteDialog(LlmModelInfo model) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return DialogComponent(
          title: '모델을 삭제할까요?',
          description: '삭제 후 다시 사용하려면 모델을 다운로드해야 합니다.',
          rightActionText: '삭제',
          rightActionTap: () {
            Navigator.pop(dialogContext);
            unawaited(_deleteModel(model));
          },
        );
      },
    );
  }

  bool _isInstalled(LlmModelInfo model) {
    return _installedModelIds.contains(OnDeviceLlmManage.localModelName(model));
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          height: 38,
          child: AppAnimation.chatting_progress_indicator,
        ),
      );
    }

    if (_errorText.isNotEmpty) {
      return Center(
        child: Text(
          _errorText,
          style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
        ),
      );
    }

    if (_models.isEmpty) {
      return Center(
        child: Text(
          '다운로드 가능한 모델이 없습니다.',
          style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.blue,
      onRefresh: _loadModels,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        itemCount: _models.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildModelRow(_models[index]),
              if (index != _models.length - 1) const CustomDividerH2G1(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModelRow(LlmModelInfo model) {
    final isInstalled = _isInstalled(model);
    final modelName = OnDeviceLlmManage.localModelName(model);
    final snapshot = _downloadSnapshots[modelName];
    final isDownloading = snapshot?.isDownloading == true;
    final isDeleting = _deletingModels.contains(modelName);
    final progress = snapshot?.progress ?? 0;
    final downloadedChunks = snapshot?.downloadedChunks ?? 0;
    final totalChunks = snapshot?.totalChunks ?? model.chunkCount;

    return ItemListForModel(
      modelName: model.modelName,
      size: model.size,
      isInstalled: isInstalled,
      isDownloading: isDownloading,
      isDeleting: isDeleting,
      progress: progress,
      downloadedChunks: downloadedChunks,
      totalChunks: totalChunks,
      onDownloadTap: () => unawaited(_downloadModel(model)),
      onDeleteTap: () => _showDeleteDialog(model),
    );
  }

  Widget _appleIntelligence() {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }
    final availability = _appleAvailability;
    final statusText = _isAppleAvailabilityLoading
        ? '확인 중'
        : availability?.isAvailable == true
            ? '사용 가능'
            : '사용 불가';
    final reason = availability?.unavailableReason.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.v30,
        Row(
          children: [
            Expanded(
              child: Text(
                'Apple Intelligence 모델',
                style: AppTextStyles.st2.copyWith(color: AppColors.g6),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 76,
              child: Text(
                statusText,
                style: AppTextStyles.bd5.copyWith(
                    color: availability?.isAvailable == true
                        ? AppColors.blue
                        : AppColors.activered),
              ),
            ),
          ],
        ),
        Gaps.v12,
        RichText(
          text: TextSpan(
            style: AppTextStyles.caption.copyWith(color: AppColors.g4),
            children: [
              const TextSpan(text: ''),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () =>
                      unawaited(AppleIntelligenceLlmManage.openSettings()),
                  child: Text(
                    '설정 > Apple Intelligence 및 Siri',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue,
                    ),
                  ),
                ),
              ),
              const TextSpan(
                text:
                    '에서 Apple Intelligence가 활성되어 있으며 모델이 다운로드되어 있어야 합니다.\n활성화 및 모델이 다운로드 되어 있는 경우 자동으로 활성화됩니다.\niOS 26 및 iPhone 15 Pro 이상에서만 사용 가능합니다.',
              ),
              if (reason.isNotEmpty) TextSpan(text: '\n$reason'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v24,
            Text(
              '온디바이스 AI 모델',
              style: AppTextStyles.st1.copyWith(color: AppColors.g6),
            ),
            Gaps.v12,
            Text(
              '기기에 저장된 모델은 서버 생성 대신 직접 답변을 만들 때 사용됩니다.',
              style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
            ),
            Gaps.v16,
            Flexible(
              fit: FlexFit.loose,
              child: _buildBody(),
            ),
            Text(
              '※ 모델 다운로드 시 데이터 사용량이 많을 수 있습니다.',
              style: AppTextStyles.caption.copyWith(color: AppColors.g4),
            ),
            _appleIntelligence(),
          ],
        ),
      ),
    );
  }
}

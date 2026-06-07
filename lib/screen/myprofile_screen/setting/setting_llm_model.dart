import 'dart:async';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';
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
      final installedModels = await OnDeviceLlmManage.getInstalledModelNames();
      final snapshots = <String, LlmModelDownloadSnapshot>{};
      for (final model in models) {
        snapshots[OnDeviceLlmManage.localModelName(model)] =
            await OnDeviceLlmManage.getDownloadSnapshot(model);
      }
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
          description: '삭제 후 다시 사용하려면 모델을 다시 다운로드해야 합니다.',
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

  String _formatModelFormat(LlmModelInfo model) {
    final format = model.normalizedFormat;
    if (format.isEmpty) {
      return '포맷 정보 없음';
    }
    return format.toUpperCase();
  }

  String _formatSize(int size) {
    if (size <= 0) {
      return '용량 정보 없음';
    }
    const gb = 1024 * 1024 * 1024;
    const mb = 1024 * 1024;
    if (size >= gb) {
      return '${(size / gb).toStringAsFixed(2)}GB';
    }
    return '${(size / mb).toStringAsFixed(0)}MB';
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
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _models.length,
        separatorBuilder: (context, index) =>
            Container(height: 1, color: AppColors.g2),
        itemBuilder: (context, index) {
          return _buildModelRow(_models[index]);
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.modelName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                ),
                Gaps.v6,
                Text(
                  '${_formatModelFormat(model)} · ${_formatSize(model.size)} · ${isInstalled ? '다운로드됨' : '미다운로드'}',
                  style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                ),
                if (isDownloading) ...[
                  Gaps.v8,
                  LinearProgressIndicator(
                    minHeight: 4,
                    value: progress <= 0 ? null : progress / 100,
                    color: AppColors.blue,
                    backgroundColor: AppColors.g2,
                  ),
                  Gaps.v6,
                  Text(
                    '$progress% · $downloadedChunks/$totalChunks',
                    style: AppTextStyles.caption.copyWith(color: AppColors.g4),
                  ),
                ],
              ],
            ),
          ),
          Gaps.h16,
          _buildActionButton(
            label: isInstalled ? '삭제' : '다운로드',
            isBusy: isDownloading || isDeleting,
            onTap: isInstalled
                ? () => _showDeleteDialog(model)
                : () => unawaited(_downloadModel(model)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isBusy,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: Container(
        width: 76,
        height: 36,
        decoration: BoxDecoration(
          color: isBusy ? AppColors.g2 : AppColors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: isBusy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.g4,
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.btn2.copyWith(color: AppColors.white),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '온디바이스 AI 모델',
              style: AppTextStyles.st1.copyWith(color: AppColors.g6),
            ),
          ),
          Gaps.v12,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '기기에 저장된 모델은 서버 생성 대신 직접 답변을 만들 때 사용됩니다.',
              style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
            ),
          ),
          Gaps.v16,
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}

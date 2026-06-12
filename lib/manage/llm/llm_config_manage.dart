import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';
import 'package:starting_block/manage/llm/llm_prompt_builder.dart';
import 'package:starting_block/manage/model_manage.dart';

class LlmConfigManage {
  static const String appleIntelligenceModelName = 'apple_intelligence';
  static const String appleIntelligenceDisplayName = 'Apple Intelligence';
  static const String _configKeyPrefix = 'llm_generation_config_';
  static const List<String> _knownModelExtensions = [
    'litertlm',
    'bin',
    'tflite',
  ];

  static Future<void> syncInstalledModelConfigs({
    required List<LlmModelInfo> availableModels,
    required Iterable<String> installedModelNames,
  }) async {
    final remoteConfigs = await LlmApi.getLlmModelConfigList();
    final remoteConfigByKey = _buildRemoteConfigMap(remoteConfigs);

    for (final installedModelName in installedModelNames) {
      final aliases = _modelAliasesForInstalled(
        installedModelName: installedModelName,
        availableModels: availableModels,
      );
      final remoteConfig = _firstConfigForAliases(remoteConfigByKey, aliases);
      if (remoteConfig == null) {
        await _saveDefaultConfig(installedModelName, aliases);
        continue;
      }
      await _saveIfNewer(remoteConfig, aliases);
    }
  }

  static Future<void> syncModelConfig(String modelName) async {
    final remoteConfigs = await LlmApi.getLlmModelConfigList();
    final aliases = _modelAliases(modelName);
    final remoteConfig = _firstConfigForAliases(
      _buildRemoteConfigMap(remoteConfigs),
      aliases,
    );
    if (remoteConfig == null) {
      await _saveDefaultConfig(modelName, aliases);
      return;
    }
    await _saveIfNewer(remoteConfig, aliases);
  }

  static Future<LlmGenerationConfig> getConfigForModel(String modelName) async {
    final prefs = await SharedPreferences.getInstance();
    for (final alias in _modelAliases(modelName)) {
      final stored = _storedConfigForKey(prefs, alias);
      if (stored != null) {
        return stored;
      }
    }
    return defaultConfig(modelName);
  }

  static Future<bool> hasConfiguredRemoteConfig(String modelName) async {
    final prefs = await SharedPreferences.getInstance();
    for (final alias in _modelAliases(modelName)) {
      final stored = _storedConfigForKey(prefs, alias);
      if (stored != null && _isRemoteConfig(stored)) {
        return true;
      }
    }
    return false;
  }

  static LlmGenerationConfig defaultConfig(String modelName) {
    return LlmGenerationConfig.defaults(
      modelName: modelName,
      systemInstruction: LlmPromptBuilder.systemInstruction,
    );
  }

  static Future<void> _saveIfNewer(
    LlmGenerationConfig remoteConfig,
    Set<String> aliases,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    for (final alias in aliases) {
      final stored = _storedConfigForKey(prefs, alias);
      if (stored == null ||
          remoteConfig.configDate.isAfter(stored.configDate)) {
        await prefs.setString(
          _storageKey(alias),
          jsonEncode(remoteConfig.copyWith(modelName: alias).toJson()),
        );
      }
    }
  }

  static Future<void> _saveDefaultConfig(
    String modelName,
    Set<String> aliases,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    for (final alias in aliases) {
      await prefs.setString(
        _storageKey(alias),
        jsonEncode(
            defaultConfig(modelName).copyWith(modelName: alias).toJson()),
      );
    }
  }

  static LlmGenerationConfig? _storedConfigForKey(
    SharedPreferences prefs,
    String modelName,
  ) {
    final rawConfig = prefs.getString(_storageKey(modelName));
    if (rawConfig == null || rawConfig.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(rawConfig);
      if (decoded is Map<String, dynamic>) {
        return LlmGenerationConfig.fromJson(decoded);
      }
      if (decoded is Map) {
        return LlmGenerationConfig.fromJson(
          decoded.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
    } catch (_) {}
    return null;
  }

  static bool _isRemoteConfig(LlmGenerationConfig config) {
    return config.configDate
        .isAfter(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
  }

  static Map<String, LlmGenerationConfig> _buildRemoteConfigMap(
    List<LlmGenerationConfig> configs,
  ) {
    final configByKey = <String, LlmGenerationConfig>{};
    for (final config in configs) {
      for (final alias in _modelAliases(config.modelName)) {
        configByKey[_modelKey(alias)] = config;
      }
    }
    return configByKey;
  }

  static LlmGenerationConfig? _firstConfigForAliases(
    Map<String, LlmGenerationConfig> configByKey,
    Set<String> aliases,
  ) {
    for (final alias in aliases) {
      final config = configByKey[_modelKey(alias)];
      if (config != null) {
        return config;
      }
    }
    return null;
  }

  static Set<String> _modelAliasesForInstalled({
    required String installedModelName,
    required List<LlmModelInfo> availableModels,
  }) {
    final aliases = _modelAliases(installedModelName);
    for (final model in availableModels) {
      final modelAliases = _modelAliases(model.modelName)
        ..addAll(_modelAliases(model.localModelName));
      if (modelAliases.map(_modelKey).any(aliases.map(_modelKey).contains)) {
        aliases.addAll(modelAliases);
      }
    }
    return aliases;
  }

  static Set<String> _modelAliases(String modelName) {
    final modelId = _modelId(modelName);
    final aliases = <String>{modelId};
    if (_isAppleIntelligenceName(modelId)) {
      aliases
        ..add(appleIntelligenceModelName)
        ..add(appleIntelligenceDisplayName);
    }
    final extensionless = _withoutKnownExtension(modelId);
    aliases.add(extensionless);
    if (!_hasKnownExtension(modelId)) {
      for (final extension in _knownModelExtensions) {
        aliases.add('$modelId.$extension');
      }
    }
    return aliases.where((alias) => alias.isNotEmpty).toSet();
  }

  static bool _isAppleIntelligenceName(String modelName) {
    final normalizedName = _normalizeModelName(modelName);
    return normalizedName == _normalizeModelName(appleIntelligenceModelName) ||
        normalizedName == _normalizeModelName(appleIntelligenceDisplayName);
  }

  static String _normalizeModelName(String modelName) {
    return modelName.trim().toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '');
  }

  static String _storageKey(String modelName) {
    return '$_configKeyPrefix${_modelKey(modelName)}';
  }

  static String _modelKey(String modelName) {
    return _modelId(modelName).toLowerCase();
  }

  static String _modelId(String modelName) {
    return Uri.parse('/$modelName').pathSegments.last.trim();
  }

  static String _withoutKnownExtension(String modelName) {
    final lowerName = modelName.toLowerCase();
    for (final extension in _knownModelExtensions) {
      final suffix = '.$extension';
      if (lowerName.endsWith(suffix)) {
        return modelName.substring(0, modelName.length - suffix.length);
      }
    }
    return modelName;
  }

  static bool _hasKnownExtension(String modelName) {
    final lowerName = modelName.toLowerCase();
    return _knownModelExtensions.any(
      (extension) => lowerName.endsWith('.$extension'),
    );
  }
}

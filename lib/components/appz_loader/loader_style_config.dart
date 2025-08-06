import 'package:flutter/material.dart';
import '../../common/token_parser.dart';

class LoaderStyleConfig {
  static final LoaderStyleConfig instance = LoaderStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();

  LoaderStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
    _config = _tokenParser.getValue<Map<String, dynamic>>(['loader'], fromSupportingTokens: true);
  }

  double size(String key) {
    if (_config == null || _config!['sizes'] == null || !_config!['sizes'].containsKey(key)) {
      throw Exception('LoaderStyleConfig: size key "$key" not found in config.');
    }
    final value = _config!['sizes'][key];
    return value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
  }
} 
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'models.dart';

/// LLM 代理客户端（Android/Windows 共用）。
///
/// 默认全部经后端代理：客户端不持有 Provider Key，代理只转发不存等级数据。
/// BYOK 是显式开关，走直连并在设置页给出风险提示。
class LlmProxyClient {
  LlmProxyClient([ProxyConfig? config])
      : _config = config ?? const ProxyConfig(baseUrl: '') {
    _dio = Dio(BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: Duration(seconds: _config.timeoutSeconds),
    ));
  }

  ProxyConfig _config;
  late Dio _dio;

  ProxyConfig get config => _config;

  void updateConfig(ProxyConfig next) {
    _config = next;
    _dio = Dio(BaseOptions(
      baseUrl: next.baseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: Duration(seconds: next.timeoutSeconds),
    ));
  }

  bool get isConfigured => _config.byokEnabled || _config.baseUrl.isNotEmpty;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_config.deviceToken.isNotEmpty)
          'Authorization': 'Bearer ${_config.deviceToken}',
      };

  /// 流式攻略。代理不可用时抛 ProxyException(offline: true)，由上层给出「离线模式」提示。
  Stream<HintChunk> streamHint(HintRequest request) async* {
    if (_config.byokEnabled) {
      yield* _byokStream(request);
      return;
    }
    if (_config.baseUrl.isEmpty) {
      throw ProxyException('未配置代理地址', offline: true);
    }

    late final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '/v1/hints',
        data: request.toJson(),
        options: Options(
          headers: _headers,
          responseType: ResponseType.stream,
        ),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }

    final body = response.data;
    if (body == null) {
      throw ProxyException('代理返回空响应');
    }

    var buffer = '';
    await for (final chunk in body.stream) {
      buffer += utf8.decode(chunk, allowMalformed: true);
      while (true) {
        final index = buffer.indexOf('\n\n');
        if (index < 0) break;
        final raw = buffer.substring(0, index);
        buffer = buffer.substring(index + 2);
        final parsed = _parseSseBlock(raw);
        if (parsed != null) {
          yield parsed;
          if (parsed.done) return;
        }
      }
    }
    // 流意外结束：补一个 done，避免 UI 一直转圈
    yield HintChunk(text: '', done: true, requestId: request.requestId);
  }

  Future<DiagnoseResponse> diagnoseNext(DiagnoseRequest request) async {
    if (_config.byokEnabled) {
      // BYOK 模式下诊断选题仍由本地算法完成，这里只做占位
      return const DiagnoseResponse(itemIds: []);
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/diagnose/next',
        data: request.toJson(),
        options: Options(headers: _headers),
      );
      return DiagnoseResponse.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Attribution> attribute(AttributeRequest request) async {
    if (_config.byokEnabled) {
      return const Attribution(tags: [], summary: '');
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/attribute',
        data: request.toJson(),
        options: Options(headers: _headers),
      );
      return Attribution.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<bool> health() async {
    if (_config.baseUrl.isEmpty) return false;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/healthz',
        options: Options(headers: _headers, receiveTimeout: const Duration(seconds: 5)),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// BYOK 直连：仅高级用户，Key 存本地安全存储（Android Keystore / Windows DPAPI）
  Stream<HintChunk> _byokStream(HintRequest request) async* {
    final dio = Dio(BaseOptions(
      baseUrl: _config.byokBaseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: Duration(seconds: _config.timeoutSeconds),
    ));
    try {
      final response = await dio.post<ResponseBody>(
        '/chat/completions',
        data: {
          'model': _config.byokModel,
          'stream': true,
          'temperature': 0.4,
          'messages': [
            {'role': 'system', 'content': byokSystemPrompt(request)},
            {'role': 'user', 'content': byokUserPrompt(request)},
          ],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_config.byokApiKey}',
          },
          responseType: ResponseType.stream,
        ),
      );
      final body = response.data;
      if (body == null) throw ProxyException('直连返回空响应');
      var buffer = '';
      await for (final chunk in body.stream) {
        buffer += utf8.decode(chunk, allowMalformed: true);
        while (true) {
          final index = buffer.indexOf('\n\n');
          if (index < 0) break;
          final raw = buffer.substring(0, index);
          buffer = buffer.substring(index + 2);
          final delta = _parseOpenAiDelta(raw);
          if (delta == null) continue;
          if (delta.isEmpty) continue;
          yield HintChunk(
            text: delta,
            level: request.hintLevel,
            requestId: request.requestId,
          );
        }
      }
      yield HintChunk(text: '', done: true, requestId: request.requestId);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  HintChunk? _parseSseBlock(String raw) {
    for (final line in raw.split('\n')) {
      if (!line.startsWith('data:')) continue;
      final payload = line.substring(5).trim();
      if (payload.isEmpty) continue;
      if (payload == '[DONE]') return const HintChunk(text: '', done: true);
      try {
        final json = jsonDecode(payload);
        if (json is Map<String, dynamic>) return HintChunk.fromJson(json);
      } catch (_) {
        // 忽略半包
      }
    }
    return null;
  }

  String? _parseOpenAiDelta(String raw) {
    for (final line in raw.split('\n')) {
      if (!line.startsWith('data:')) continue;
      final payload = line.substring(5).trim();
      if (payload.isEmpty || payload == '[DONE]') continue;
      try {
        final json = jsonDecode(payload);
        final choices = (json as Map<String, dynamic>)['choices'];
        if (choices is List && choices.isNotEmpty) {
          final delta = (choices.first as Map<String, dynamic>)['delta'];
          if (delta is Map<String, dynamic>) {
            final content = delta['content'];
            if (content is String) return content;
          }
        }
      } catch (_) {
        // 忽略
      }
    }
    return null;
  }

  ProxyException _mapError(DioException e) {
    final code = e.response?.statusCode;
    if (code == 401) {
      return ProxyException('设备未授权，请在设置里重新激活', statusCode: code);
    }
    if (code == 429) {
      return ProxyException('请求太频繁，歇一会儿再问', statusCode: code);
    }
    if (code != null && code >= 500) {
      return ProxyException('代理服务异常（$code）', statusCode: code);
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ProxyException('当前离线，攻略不可用', offline: true);
    }
    return ProxyException(e.message ?? '请求失败', statusCode: code);
  }

  String byokSystemPrompt(HintRequest r) {
    final scope = r.outOfScope ? '学习者水平远低于本题，必须降阶解释，禁止堆高级术语。' : '';
    return '你是语言学习软件「卡点」的精讲老师。绝对不要替学习者做题，'
        '不要说出正确选项的原文。当前提示层级 ${r.hintLevel}（1 最浅，4 才可揭示答案）。'
        '用中文解释，日语/英语的例词保留原语言。$scope';
  }

  String byokUserPrompt(HintRequest r) {
    final buffer = StringBuffer()
      ..writeln('学科：${r.subject}')
      ..writeln('题型/意图：${r.intent}（选中类型：${r.selectionKind}）')
      ..writeln('选中文本：${r.selectedText}')
      ..writeln('题干：${r.question}');
    if (r.options.isNotEmpty) buffer.writeln('选项：${r.options.join(' / ')}');
    if (r.passageExcerpt.isNotEmpty) {
      buffer.writeln('上下文：${r.passageExcerpt}');
    }
    buffer.writeln('学习者等级摘要：${jsonEncode(r.learnerLevelSummary)}');
    return buffer.toString();
  }
}

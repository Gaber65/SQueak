import 'dart:collection';

import 'package:flutter/foundation.dart';

class ApiCall {
  final String id;
  final String method;
  final String url;
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;
  int? statusCode;
  final Map<String, dynamic>? responseHeaders;
  dynamic responseBody;
  DateTime timestamp;
  Duration? duration;
  String? error;

  ApiCall({
    required this.id,
    required this.method,
    required this.url,
    this.requestHeaders,
    this.requestBody,
    this.statusCode,
    this.responseHeaders,
    this.responseBody,
    DateTime? timestamp,
    this.duration,
    this.error,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Simple singleton logger that holds recent API calls and notifies listeners.
class ApiLogger extends ChangeNotifier {
  ApiLogger._internal();

  static final ApiLogger _instance = ApiLogger._internal();
  static ApiLogger get instance => _instance;

  final List<ApiCall> _calls = [];

  UnmodifiableListView<ApiCall> get calls =>
      UnmodifiableListView(_calls.reversed);

  final ValueNotifier<int> callsCount = ValueNotifier<int>(0);

  void addCall(ApiCall call) {
    _calls.add(call);
    callsCount.value = _calls.length;
    notifyListeners();
  }

  void updateCall(
    String id, {
    int? statusCode,
    dynamic responseBody,
    Map<String, dynamic>? responseHeaders,
    Duration? duration,
    String? error,
  }) {
    final idx = _calls.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    final old = _calls[idx];
    final updated = ApiCall(
      id: old.id,
      method: old.method,
      url: old.url,
      requestHeaders: old.requestHeaders,
      requestBody: old.requestBody,
      statusCode: statusCode ?? old.statusCode,
      responseHeaders: responseHeaders ?? old.responseHeaders,
      responseBody: responseBody ?? old.responseBody,
      timestamp: old.timestamp,
      duration: duration ?? old.duration,
      error: error ?? old.error,
    );
    _calls[idx] = updated;
    notifyListeners();
  }

  void clear() {
    _calls.clear();
    callsCount.value = 0;
    notifyListeners();
  }
}

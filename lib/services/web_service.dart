import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../config/web_config.dart';
import '../utils/mime_utils.dart';

class WebService {
  static final WebService _instance = WebService._internal();
  factory WebService() => _instance;
  WebService._internal();
  
  late HttpClient _httpClient;
  
  void initialize() {
    _httpClient = HttpClient();
    _httpClient.connectionTimeout = WebConfig.connectionTimeout;
    
    // Configure for web compatibility
    if (kIsWeb) {
      _configureForWeb();
    }
  }
  
  void _configureForWeb() {
    // Web-specific configurations
    _httpClient.badCertificateCallback = (cert, host, port) => true;
  }
  
  /// Makes HTTP request with MIME type validation
  Future<WebResponse> makeRequest({
    required String url,
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
    bool validateMimeType = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = await _httpClient.openUrl(method, uri);
      
      // Add headers
      final fileExtension = MimeUtils.getFileExtension(url);
      final requestHeaders = headers ?? MimeUtils.getHeadersForFileType(fileExtension);
      
      requestHeaders.forEach((key, value) {
        request.headers.set(key, value);
      });
      
      // Add body if present
      if (body != null) {
        if (body is String) {
          request.write(body);
        } else {
          request.write(jsonEncode(body));
        }
      }
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      // Validate MIME type if required
      if (validateMimeType) {
        final contentType = response.headers.contentType?.toString();
        final isValidMime = _validateResponseMimeType(url, contentType, fileExtension);
        
        if (!isValidMime) {
          return WebResponse(
            statusCode: response.statusCode,
            body: responseBody,
            headers: _extractHeaders(response),
            success: false,
            error: WebConfig.mimeTypeError,
            mimeTypeValid: false,
          );
        }
      }
      
      return WebResponse(
        statusCode: response.statusCode,
        body: responseBody,
        headers: _extractHeaders(response),
        success: response.statusCode >= 200 && response.statusCode < 300,
        mimeTypeValid: true,
      );
      
    } catch (e) {
      return WebResponse(
        statusCode: 0,
        body: '',
        headers: {},
        success: false,
        error: e.toString(),
        mimeTypeValid: false,
      );
    }
  }
  
  bool _validateResponseMimeType(String url, String? contentType, String fileExtension) {
    if (fileExtension.isEmpty) return true; // Skip validation for URLs without extensions
    
    final isValid = MimeUtils.isValidMimeType(contentType, fileExtension);
    
    if (!isValid) {
      final expectedType = MimeUtils.getExpectedMimeType(fileExtension);
      MimeUtils.logMimeTypeError(url, contentType, expectedType ?? 'unknown');
    }
    
    return isValid;
  }
  
  Map<String, String> _extractHeaders(HttpClientResponse response) {
    final headers = <String, String>{};
    response.headers.forEach((name, values) {
      headers[name] = values.join(', ');
    });
    return headers;
  }
  
  /// Specifically for loading JavaScript files with proper MIME type handling
  Future<WebResponse> loadJavaScript(String url) async {
    return makeRequest(
      url: url,
      headers: WebConfig.jsHeaders,
      validateMimeType: true,
    );
  }
  
  /// Preload critical resources with MIME validation
  Future<List<WebResponse>> preloadResources(List<String> urls) async {
    final futures = urls.map((url) => makeRequest(url: url));
    return await Future.wait(futures);
  }
  
  void dispose() {
    _httpClient.close();
  }
}

class WebResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;
  final bool success;
  final String? error;
  final bool mimeTypeValid;
  
  WebResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
    required this.success,
    this.error,
    required this.mimeTypeValid,
  });
  
  String? get contentType => headers['content-type'];
  
  bool get isJavaScript {
    return contentType != null && 
           MimeUtils.isValidJavaScriptMimeType(contentType!);
  }
  
  @override
  String toString() {
    return 'WebResponse(statusCode: $statusCode, success: $success, mimeTypeValid: $mimeTypeValid, error: $error)';
  }
}
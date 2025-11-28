import '../config/web_config.dart';

class MimeUtils {
  /// Validates if the response MIME type matches expected type
  static bool isValidMimeType(String? contentType, String expectedExtension) {
    if (contentType == null) return false;
    
    final expectedMimeType = WebConfig.allowedMimeTypes[expectedExtension];
    if (expectedMimeType == null) return false;
    
    // Extract main MIME type (ignore charset and other parameters)
    final mainContentType = contentType.split(';').first.trim().toLowerCase();
    
    return mainContentType == expectedMimeType.toLowerCase();
  }
  
  /// Gets expected MIME type for file extension
  static String? getExpectedMimeType(String extension) {
    return WebConfig.allowedMimeTypes[extension];
  }
  
  /// Extracts file extension from URL
  static String getFileExtension(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    
    // Handle special cases like .dart.js
    if (path.endsWith('.dart.js')) {
      return '.dart.js';
    }
    
    final lastDotIndex = path.lastIndexOf('.');
    if (lastDotIndex == -1) return '';
    
    return path.substring(lastDotIndex);
  }
  
  /// Validates JavaScript file MIME type specifically
  static bool isValidJavaScriptMimeType(String? contentType) {
    if (contentType == null) return false;
    
    final mainContentType = contentType.split(';').first.trim().toLowerCase();
    
    return mainContentType == 'application/javascript' ||
           mainContentType == 'text/javascript' ||
           mainContentType == 'application/x-javascript';
  }
  
  /// Creates appropriate headers for different file types
  static Map<String, String> getHeadersForFileType(String extension) {
    switch (extension) {
      case '.js':
      case '.dart.js':
        return WebConfig.jsHeaders;
      default:
        return WebConfig.defaultHeaders;
    }
  }
  
  /// Logs MIME type validation errors for debugging
  static void logMimeTypeError(String url, String? receivedType, String expectedType) {
    print('MIME Type Error:');
    print('URL: $url');
    print('Received: ${receivedType ?? "null"} ');
    print('Expected: $expectedType');
    print('This may cause script execution to fail in web browsers.');
  }
}
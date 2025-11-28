class WebConfig {
  static const String baseUrl = 'https://laserjet.trybrainbox.com';
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl/api/$apiVersion';
  
  // MIME type configurations
  static const Map<String, String> allowedMimeTypes = {
    '.js': 'application/javascript',
    '.dart.js': 'application/javascript',
    '.css': 'text/css',
    '.html': 'text/html',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.woff': 'font/woff',
    '.woff2': 'font/woff2',
    '.ttf': 'font/ttf',
  };
  
  // Headers for web requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Cache-Control': 'no-cache',
  };
  
  // JavaScript specific headers
  static const Map<String, String> jsHeaders = {
    'Content-Type': 'application/javascript',
    'Accept': 'application/javascript, text/javascript',
    'Cache-Control': 'public, max-age=31536000',
  };
  
  // Timeout configurations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Error messages
  static const String mimeTypeError = 'Invalid MIME type received from server';
  static const String connectionError = 'Failed to connect to server';
  static const String timeoutError = 'Request timeout';
}
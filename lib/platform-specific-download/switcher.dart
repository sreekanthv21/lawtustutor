
export 'error.dart' // Default fallback
  if (dart.library.html) 'web.dart' // Web
  if (dart.library.io) 'mobile.dart';   // Mobile/Desktop
import 'package:universal_platform/universal_platform.dart';

bool isIOS = UniversalPlatform.isIOS;
bool isAndroid = UniversalPlatform.isAndroid;
bool isMacOS = UniversalPlatform.isMacOS;
bool isWindows = UniversalPlatform.isWindows;
bool isLinux = UniversalPlatform.isLinux;
bool isFuchsia = UniversalPlatform.isFuchsia;
bool isWeb = UniversalPlatform.isWeb;
bool isDesktop = isWindows || isLinux || isFuchsia || isMacOS;
bool isMobile = isAndroid || isIOS;

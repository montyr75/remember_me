import 'dart:html';

import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;

String appName;
Logger log;

enum AppMode {
  Production,
  Develop
}

final AppMode appMode =
window.location.host.contains('localhost') ? AppMode.Develop : AppMode.Production;

Logger initLog(String _appName) {
  DateFormat dateFormatter = new DateFormat("H:m:s.S");

  appName = _appName;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (appMode == AppMode.Develop) {
      print('${rec.level.name} (${dateFormatter.format(rec.time)}): ${rec.message}');
    }
  });

  return new Logger(appName);
}
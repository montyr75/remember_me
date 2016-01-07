library remember_me.web.index;

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer/polymer.dart';

import 'package:remember_me/views/main_app/main_app.dart';
import 'package:remember_me/services/logger.dart' as Logger;

const String APP_NAME = "remember_me";

main() async {
  Logger.log = Logger.initLog(APP_NAME);
  await initPolymer();
}

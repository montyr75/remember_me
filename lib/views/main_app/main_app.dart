@HtmlImport('main_app.html')
library remember_me.lib.views.main_app;

import 'dart:html';
//import 'dart:async';

import '../../model/global.dart';
import '../settings_view/settings_view.dart';
import '../game_view/game_view.dart';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('main-app')
class MainApp extends PolymerElement {

  // views
  static const String SETTINGS_VIEW = "settings";
  static const String GAME_VIEW = "game";

  SettingsView settingsView;
  GameView gameView;

  @reflectable String currentView;

  MainApp.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");

    settingsView = $['settings-view'];
    gameView = $['game-view'];

    showSettingsView();
  }

  @reflectable void showSettingsView([Event event, var detail]) {
    log.info("$runtimeType::showSettingsView()");

    set('currentView', SETTINGS_VIEW);
  }

  @reflectable void showGameView(Event event, Map config) {
    log.info("$runtimeType::showGameView() -- $config");

    gameView.init(config);

    set('currentView', GAME_VIEW);
  }

  @reflectable bool isGameView(String currentView) => currentView == GAME_VIEW;

  @reflectable void replay(Event event, var detail) {
    log.info("$runtimeType::replay()");

    gameView.init();  }
}


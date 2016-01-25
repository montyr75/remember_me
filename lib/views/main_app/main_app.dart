@HtmlImport('main_app.html')
library remember_me.lib.views.main_app;

import 'dart:html';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import '../../services/logger.dart';
import '../../model/game_model/game_model.dart';
import '../settings_view/settings_view.dart';
import '../game_view/game_view.dart';

@PolymerRegister('main-app')
class MainApp extends PolymerElement with AutonotifyBehavior, Observable {

  // views
  static const String SETTINGS_VIEW = "settings";
  static const String GAME_VIEW = "game";

  @observable @property GameModel model;
  GameView gameView;

  @observable @property String currentView;

  MainApp.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");

    model = $['model'];
    gameView = $['game-view'];

    showSettingsView();
  }

  @reflectable void showSettingsView([Event event, var detail]) {
    log.info("$runtimeType::showSettingsView()");

    currentView = SETTINGS_VIEW;
  }

  @reflectable void showGameView(Event event, var detail) {
    log.info("$runtimeType::showGameView()");

    newGame();

    currentView = GAME_VIEW;
  }

  @reflectable bool isGameView(String currentView) => currentView == GAME_VIEW;

  @reflectable void newGame([Event event, var detail]) {
    log.info("$runtimeType::newGame()");

    gameView.newGame();
  }
}


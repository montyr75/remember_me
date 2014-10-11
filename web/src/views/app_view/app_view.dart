library app_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../../model/game_model.dart';
import '../game_view/game_view.dart';

@CustomTag('app-view')
class AppView extends PolymerElement {

  static const String CLASS_NAME = "AppView";

  // views
  static const int SETTINGS_VIEW = 0;
  static const int GAME_VIEW = 1;

  @observable GameModel model;
  @observable GameView gameViewElement;

  @observable int currentView;

  AppView.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

    model = $['model'];
    gameViewElement = $['game-view'];
  }

  void showSettingsView([Event event, var detail, Element target]) {
    print("$CLASS_NAME::showSettingsView()");

    currentView = SETTINGS_VIEW;
  }

  // run by <game-model> on-deck-ready
  void showGameView(Event event, var detail, Element target) {
    print("$CLASS_NAME::showGameView()");

    currentView = GAME_VIEW;
    gameViewElement.init();
  }

  void replay(Event event, var detail, Element target) {
    print("$CLASS_NAME::replay()");

    // this will destroy the current game view
    currentView = null;

    // this will recreate the game view with the current settings
    Timer.run(model.newGame);   // use async?
  }

  int get settingsView => SETTINGS_VIEW;
  int get gameView => GAME_VIEW;
}


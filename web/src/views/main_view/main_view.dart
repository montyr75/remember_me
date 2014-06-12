library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../../model/model.dart';
import '../../model/events.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {
  // views
  static const SETTINGS_VIEW = "settings_view";
  static const GAME_VIEW = "game_view";

  @observable Model model;

  @observable String currentView;

  StreamSubscription<String> _modelReadyEventSub;   // fired when model is ready for first use
  StreamSubscription<String> _deckReadyEventSub;    // fired when a new game's deck is ready for play

  MainView.created() : super.created();

  @override void attached() {
    super.attached();
    print("MainView::attached()");

    // listen for events
    _modelReadyEventSub = eventBus.on(modelReadyEvent).listen(_initComplete);
    _deckReadyEventSub = eventBus.on(deckReadyEvent).listen(showGameView);
    document.addEventListener("touchstart", (_) => true);

    model = new Model();
  }

  void _initComplete(_) {
    print("MainView::_initComplete()");

    _modelReadyEventSub.cancel();

    showSettingsView();
  }

  void showSettingsView([Event event, var detail, Element target]) {
    print("MainView::showSettingsView()");

    currentView = SETTINGS_VIEW;
  }

  void showGameView(_) {
    print("MainView::showGameView()");

    currentView = GAME_VIEW;
  }

  void replay(Event event, var detail, Element target) {
    print("MainView::replay()");

    // this will destroy the current game view
    currentView = null;

    // this will recreate the game view with the current settings
    Timer.run(model.newGame);
  }
}


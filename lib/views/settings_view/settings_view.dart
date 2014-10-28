library settings_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/global.dart';
import '../../model/game_model.dart';

@CustomTag('settings-view')
class SettingsView extends PolymerElement {

  @published GameModel model;

  SettingsView.created() : super.created();

  @override void attached() {
    super.attached();
    log.info("$runtimeType::attached()");
  }

  void deckSelected(Event event, var detail, var target) {
    if (detail['isSelected']) {
      log.info("$runtimeType::deckSelected() -- ${target.selected}");

      model.currentDeck = model.decks[target.selected];
    }
  }

  void difficultySelected(Event event, var detail, var target) {
    if (detail['isSelected']) {
      log.info("$runtimeType::difficultySelected() --  ${target.selected}");

      model.numCards = model.difficulties[target.selected];
    }
  }

  void start(Event event, var detail, Element target) {
    log.info("$runtimeType::start()");

    model.newGame();
  }
}


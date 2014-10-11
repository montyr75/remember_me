library settings_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/game_model.dart';

@CustomTag('settings-view')
class SettingsView extends PolymerElement {

  static const String CLASS_NAME = "SettingsView";

  @published GameModel model;

  SettingsView.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");
  }

  void deckSelected(Event event, var detail, var target) {
    if (detail['isSelected']) {
      print("$CLASS_NAME::deckSelected() -- ${target.selected}");

      model.currentDeck = model.decks[target.selected];
    }
  }

  void difficultySelected(Event event, var detail, var target) {
    if (detail['isSelected']) {
      print("$CLASS_NAME::difficultySelected() --  ${target.selected}");

      model.numCards = model.difficulties[target.selected];
    }
  }

  void start(Event event, var detail, Element target) {
    print("$CLASS_NAME::start()");

    model.newGame();
  }
}


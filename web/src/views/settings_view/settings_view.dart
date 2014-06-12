library settings_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/model.dart';

@CustomTag('settings-view')
class SettingsView extends PolymerElement {

  @published Model model;

  SettingsView.created() : super.created();

  @override void attached() {
    super.attached();
    print("SettingsView::attached()");
  }

  void deckSelected(Event event, var detail, var target) {
    print("SettingsView::deckSelected()");

    model.currentDeck = model.decks[target.selected];
  }

  void difficultySelected(Event event, var detail, var target) {
    print("SettingsView::difficultySelected()");

    model.numCards = model.difficulties[target.selected];
  }

  void start(Event event, var detail, Element target) {
    print("SettingsView::start()");

    model.newGame();
  }

  // prevent app reload on <form> submission
  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}


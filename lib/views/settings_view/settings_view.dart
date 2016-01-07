@HtmlImport('settings_view.html')
library remember_me.lib.views.settings_view;

import 'dart:html';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_selector.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/firebase_document.dart';
import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import '../../services/logger.dart';
import '../../model/game_model/game_model.dart';
import '../../model/deck.dart';
import '../../styles/animate_css.dart';

@PolymerRegister('settings-view')
class SettingsView extends PolymerElement with AutonotifyBehavior, Observable {

  // paths
  static const String BASE_IMAGE_PATH = "resources/images";
  static const String BASE_DECK_IMAGE_PATH = "$BASE_IMAGE_PATH/decks";

  @Property(observer: 'modelArrived') GameModel model;

  @Property(observer: 'decksLoaded') Map deckMaps;
  @observable @property List<Deck> decks = new ObservableList();
  @observable bool dataLoaded = false;    // when true, this will show the UI

  @property final List<int> difficulties = const <int>[4, 8, 12];

  SettingsView.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");
  }

  @reflectable void modelArrived([_, __]) {
    log.info("$runtimeType::modelArrived()");
  }

  @reflectable void decksLoaded([_, __]) {
    log.info("$runtimeType::decksLoaded()");

    deckMaps.forEach((String key, Map deck) {
      decks.add(new Deck.fromMap(BASE_DECK_IMAGE_PATH, key, deck));
    });

    dataLoaded = true;
  }

  @reflectable void deckSelected(CustomEvent event, var detail) {
    model.currentDeck = decks[(event.target as IronSelector).selected];

    log.info("$runtimeType::deckSelected() -- ${model.currentDeck}");
  }

  @reflectable void difficultySelected(CustomEvent event, var detail) {
    model.numCards = difficulties[(event.target as IronSelector).selected];

    log.info("$runtimeType::difficultySelected() -- ${model.numCards}");
  }

  @reflectable bool readyToStart(Deck currentDeck, int numCards) => currentDeck != null && numCards != null;

  @reflectable void newGame(Event event, var detail) {
    log.info("$runtimeType::newGame()");

    fire("new-game");
  }
}


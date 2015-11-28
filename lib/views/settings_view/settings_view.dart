@HtmlImport('settings_view.html')
library remember_me.lib.views.settings_view;

import 'dart:html';
import '../../model/global.dart';
import '../../model/cards.dart';
import '../../styles/animate_css.dart';

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_selector.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/firebase_document.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('settings-view')
class SettingsView extends PolymerElement {

  // paths
  static const String BASE_IMAGE_PATH = "resources/images";
  static const String BASE_DECK_IMAGE_PATH = "$BASE_IMAGE_PATH/decks";

  @Property(observer: 'decksLoaded') Map deckMaps;
  @property List<Deck> decks = [];
  @property bool dataLoaded = false;

  @property final List<int> difficulties = const <int>[4, 8, 12];

  @property Deck currentDeck;
  @property int numCards;   // difficulty is determined by how many cards are used in a game

  SettingsView.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");
    fire("ready");
  }

  @reflectable void decksLoaded([_, __]) {
    log.info("$runtimeType::decksLoaded()");

    deckMaps.forEach((String key, Map deck) {
      add('decks', new Deck.fromMap(BASE_DECK_IMAGE_PATH, key, deck));
    });

    set('dataLoaded', true);
  }

  @reflectable void deckSelected(CustomEvent event, var detail) {
    set('currentDeck', decks[(event.target as IronSelector).selected]);

    log.info("$runtimeType::deckSelected() -- $currentDeck");
  }

  @reflectable void difficultySelected(CustomEvent event, var detail) {
    set('numCards', difficulties[(event.target as IronSelector).selected]);

    log.info("$runtimeType::deckSelected() -- $numCards");
  }

  @reflectable bool readyToStart(Event event, var detail) => currentDeck != null && numCards != null;

  @reflectable void start(Event event, var detail) {
    log.info("$runtimeType::start()");

    fire("new-game", detail: {
      "currentDeck": currentDeck,
      "numCards": numCards
    });
  }
}


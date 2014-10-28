library game_model;

import 'package:polymer/polymer.dart';
import 'global.dart';
import 'dart:html';
import 'dart:async';
import 'cards.dart';

@CustomTag('game-model')
class GameModel extends PolymerElement {

  // paths
  static const String DECK_DATA_PATH = "resources/data/decks/";
  static const String DECK_DATA_FILENAME = "_decks.json";
  static const String IMAGES_PATH = "resources/images/";

  final List<Deck> decks = toObservable([]);
  @observable Deck currentDeck;
  @observable int numCards;   // difficulty is determined by how many cards are used in a game
  final List<int> difficulties = const [4, 6, 8, 12];

  StreamSubscription<String> _deckReadySub;

  GameModel.created() : super.created();

  @override void attached() {
    super.attached();
    log.info("$runtimeType::attached()");
  }

  void dataLoaded(Event event, var detail, Element target) {
    List<Map<String, String>> deckMaps = detail['response'];

    deckMaps.forEach((Map<String, String> deck) {
      decks.add(new Deck.fromMap(deck, DECK_DATA_PATH));
    });
  }

  void newGame() {
    log.info("$runtimeType::newGame()");

    // make sure selected deck has loaded its cards
    _deckReadySub = currentDeck.onDeckReady.listen(_deckReady);
    currentDeck.createGameDeck((numCards / 2).floor());
  }

  void _deckReady(_) {
    _deckReadySub.cancel();
    fire("deck-ready");
  }

  String get dataPath => "$DECK_DATA_PATH$DECK_DATA_FILENAME";
  String get images_path => IMAGES_PATH;
}
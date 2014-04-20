library cards;

// include Polymer to have access to @observable
import 'package:polymer/polymer.dart';

import 'dart:convert';
import 'events.dart';
import 'dart:html';

class Card extends Object with Observable {
  String id;
  @observable String title;
  @observable String imageFilename;

  @observable bool flipped = false;
  @observable bool matched = false;

  Card(String this.id, String this.title, String this.imageFilename);

  Card.fromMap(Map<String, String> map) : this(map["id"], map["title"], map["imageFilename"]);

  void flip() {
    flipped = !flipped;
  }

  void match() {
    matched = !matched;
  }

  String toString() => title;
}

class Deck extends Object with Observable {
  String title;
  String baseImagePath;
  String backImageURL;
  String _cardsFileURL;

  List<Map<String, String>> _cardMaps;   // includes all cards in the deck
  @observable List<Card> cards = toObservable([]);  // just the cards being used in the current game

  int _numPairs;

  Deck.fromMap(Map<String, String> deckMap, String cardsFilePath) {
    title = deckMap["title"];
    baseImagePath = deckMap["baseImagePath"];
    backImageURL = "${baseImagePath}${deckMap['backImageFilename']}";
    _cardsFileURL = "${cardsFilePath}${deckMap['cardsFilename']}";
  }

  // this public function is called when this deck is selected for a game
  void createGameDeck(int numPairs) {
    void _prepareGameDeck() {
      _cardMaps.shuffle();

      cards.clear();

      // take only the number of cards we need and add 2 of each to the game deck
      _cardMaps.take(numPairs).forEach((Map<String, String> card) {
        cards.add(new Card.fromMap(card));
        cards.add(new Card.fromMap(card));
      });

      cards.shuffle();

      eventBus.fire(deckReadyEvent, null);
    }

    void _loadCards() {
      HttpRequest.getString(_cardsFileURL).then((String jsonStr) {
        _cardMaps = JSON.decode(jsonStr);
        _prepareGameDeck();
      });
    }

    _numPairs = numPairs;

    if (_cardMaps == null) {
      _loadCards();
    }
    else {
      _prepareGameDeck();
    }
  }

  int get numPairs => _numPairs;

  String toString() {
    StringBuffer sb = new StringBuffer();

    cards.forEach((Card card) => sb.writeln(card));

    return sb.toString();
  }
}
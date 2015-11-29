library remember_me.lib.model.cards;

import 'package:polymer/polymer.dart';

class Card extends JsProxy {
  int id;
  @reflectable String title;
  String imageFilename;

  @reflectable String imageURL;
  @reflectable String backImageURL;

  @reflectable bool flipped = false;
  @reflectable bool matched = false;

  Card();

  Card.fromData(int this.id, String this.title, String this.imageFilename, String imagePath, String this.backImageURL) {
    imageURL = "$imagePath/$imageFilename";
  }

  Card.fromMap(int id, String imagePath, String backImageURL, Map map) : this.fromData(id, map["title"], map["imageFilename"], imagePath, backImageURL);

  Card clone() => new Card()
      ..id = id
      ..title = title
      ..imageURL = imageURL
      ..backImageURL = backImageURL;

  @override String toString() => title;
}

class Deck extends JsProxy {
  @reflectable String title;
  String imagePath;
  String backImageFilename;

  List<Card> _cards = [];   // includes all cards in the deck

  String fullImagePath;
  @reflectable String backImageURL;

  Deck.fromMap(String baseImagePath, String title, Map deckMap) {
    this.title = title;
    imagePath = deckMap["imagePath"];
    backImageFilename = deckMap['backImageFilename'];

    fullImagePath = "$baseImagePath/$imagePath";
    backImageURL = "$fullImagePath/$backImageFilename";

    int id = 0;
    deckMap['cards'].forEach((Map card) => _cards.add(new Card.fromMap(id++, fullImagePath, backImageURL, card)));
  }

  // this public function is called when this deck is selected for a game
  List<Card> createGameDeck(int numPairs) {
    _cards.shuffle();

    List<Card> gameDeck = [];

    // take only the number of cards we need and add 2 of each to the game deck
    // use clones so that each card-view is working with its own copy
    _cards.take(numPairs).forEach((Card card) {
      gameDeck.add(card.clone());
      gameDeck.add(card.clone());
    });

    return gameDeck..shuffle();
  }

  @override String toString() => title;
}
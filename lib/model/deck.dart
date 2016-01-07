library remember_me.lib.model.deck;

import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import "package:polymer/polymer.dart";

import 'card.dart';

class Deck extends Observable {
  @observable String title;
  String imagePath;
  String backImageFilename;

  List<Card> _cards = [];   // includes all cards in the deck

  String fullImagePath;
  @observable String backImageURL;

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
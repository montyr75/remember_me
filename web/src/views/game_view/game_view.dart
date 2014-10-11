library game_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/game_model.dart';
import 'dart:async';
import '../../model/cards.dart';

@CustomTag('game-view')
class GameView extends PolymerElement {

  static const String CLASS_NAME = "GameView";

  @published GameModel model;

  StreamSubscription<String> _cardFlippedEventSub;    // fired when card is flipped over

  // game data
  @observable int matchesNeeded;
  @observable int unmatchedPairs;
  @observable int attempts;
  Card firstPick;
  Card secondPick;
  @observable bool interfaceEnabled;
  @observable bool win = false;

  GameView.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

//    _setboardWidth();

    // set game data
//    _resetGameData();
  }

  void init() {
    _resetGameData();
  }

  void _resetGameData() {
    matchesNeeded = unmatchedPairs = model.currentDeck.numPairs;
    attempts = 0;
    firstPick = null;
    secondPick = null;
    interfaceEnabled = true;
    win = false;
  }

  void _setboardWidth() {
    String boardWidthClass;

    var board = $['board'];
    var footer = $['footer'];

    board.classes.remove();

    if (model.numCards > 4 && model.numCards % 4 == 0) {
      boardWidthClass = "row4";
    }
    else if (model.numCards % 3 == 0) {
      boardWidthClass = "row3";
    }
    else if (model.numCards % 2 == 0) {
      boardWidthClass = "row2";
    }
    else {
      boardWidthClass = "row4";
    }

    this.classes.add(boardWidthClass);
  }

  void cardFlipped(Event event, Card card, Element target) {
    print("GameView::cardFlipped() -- $card");

    if (firstPick == null) {
      firstPick = card;
    }
    else if (secondPick == null) {
      interfaceEnabled = false;
      secondPick = card;
      attempts++;

      // check for match
      if (firstPick.id == secondPick.id) {
        // delay this to allow animations to finish
        new Timer(new Duration(seconds: 1), _matchMade);
      }
      else {
        // delay this to allow animations to finish
        new Timer(new Duration(seconds: 2), _noMatchMade);
      }
    }
  }

  void _matchMade() {
    print("Match!");

    firstPick.match();
    secondPick.match();
    firstPick = secondPick = null;
    unmatchedPairs--;
    interfaceEnabled = true;

    // check for a win
    if (unmatchedPairs == 0) {
      print("Win!");

      interfaceEnabled = false;
      win = true;
      _unmatchAll();
    }
  }

  void _noMatchMade() {
    print("No match.");

    firstPick.flip();
    secondPick.flip();
    firstPick = secondPick = null;
    interfaceEnabled = true;
  }

  void _unmatchAll() {
    model.currentDeck.cards.forEach((Card card) => card.match());
  }
}


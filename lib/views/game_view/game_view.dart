@HtmlImport('game_view.html')
library remember_me.lib.views.game_view;

import 'dart:html';
import 'dart:async';
import '../../model/global.dart';
import '../../model/cards.dart';
import '../card_view/card_view.dart';
import '../../styles/animate_css.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('game-view')
class GameView extends PolymerElement {

  Deck currentDeck;
  int numCards;   // difficulty is determined by how many cards are used in a game
  int numPairs;      // number of card pairs in the current game

  CardView firstPick;
  CardView secondPick;

  @property List<Card> gameCards = [];  // just the cards being used in the current game
  @property int matchesNeeded;
  @property int unmatchedPairs;
  @property int attempts;
  @property bool win = false;
  @property bool interfaceEnabled;

  GameView.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");
  }

  void init([Map config]) {
    log.info("$runtimeType::init()");

    if (config != null) {
      currentDeck = config['currentDeck'];
      numCards = config['numCards'];
      _setBoardWidth();
    }

    numPairs = (numCards / 2).floor();

    firstPick = null;
    secondPick = null;

    setAll('gameCards', 0, currentDeck.createGameDeck(numPairs));

    set('matchesNeeded', numPairs);
    set('unmatchedPairs', numPairs);
    set('attempts', 0);
    set('win', false);
    set('interfaceEnabled', true);
  }

  @reflectable void cardFlipped(Event event, var detail) {
    CardView cardView = event.target;

    log.info("$runtimeType::cardFlipped() -- ${cardView.card}");

    if (firstPick == null) {
      firstPick = cardView;
    }
    else if (secondPick == null) {
      set('interfaceEnabled', false);
      attempts++; notifyPath('attempts', attempts);
      secondPick = cardView;

      // check for match
      if (firstPick.card.id == secondPick.card.id) {
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
    log.info("$runtimeType::_matchMade()");

    firstPick.match();
    secondPick.match();
    firstPick = secondPick = null;
    unmatchedPairs--; notifyPath('unmatchedPairs', unmatchedPairs);
    set('interfaceEnabled', true);

    // check for a win
    if (unmatchedPairs == 0) {
      log.info("Win!");

      set('interfaceEnabled', false);
      set('win', true);
      _unmatchAll();
    }
  }

  void _noMatchMade() {
    log.info("$runtimeType::_noMatchMade()");

    firstPick.flip();
    secondPick.flip();
    firstPick = secondPick = null;
    set('interfaceEnabled', true);
  }

  void _unmatchAll() {
    Polymer.dom(parent).querySelectorAll(".card").forEach((CardView cardView) => cardView.match());
  }

  void _setBoardWidth() {
    String boardWidthAttribute;
    DivElement board = $['wrapper'];

    Polymer.dom(board).removeAttribute("row2");
    Polymer.dom(board).removeAttribute("row3");
    Polymer.dom(board).removeAttribute("row4");

    if (numCards > 4 && numCards % 4 == 0) {
      boardWidthAttribute = "row4";
    }
    else if (numCards % 3 == 0) {
      boardWidthAttribute = "row3";
    }
    else if (numCards % 2 == 0) {
      boardWidthAttribute = "row2";
    }

    Polymer.dom(board).setAttribute(boardWidthAttribute, true);
  }
}


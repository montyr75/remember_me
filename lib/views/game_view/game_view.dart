@HtmlImport('game_view.html')
library remember_me.lib.views.game_view;

import 'dart:html';
import 'dart:async';

import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import '../../services/logger.dart';
import '../../model/game_model/game_model.dart';
import '../../model/card.dart';
import '../card_view/card_view.dart';
import '../../styles/animate_css.dart';

@PolymerRegister('game-view')
class GameView extends PolymerElement with AutonotifyBehavior, Observable {

  @Property(observer: 'modelArrived') GameModel model;

  int numPairs;      // number of card pairs in the current game

  Card firstPick;
  Card secondPick;

  @observable @property List<Card> gameCards;
  @observable int matchesNeeded;
  @observable int unmatchedPairs;
  @observable int attempts;
  @observable bool win = false;

  @observable bool hideBoard = true;
  @observable bool interfaceEnabled = false;

  Timer _animationTimer;

  GameView.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");
  }

  @reflectable void modelArrived([_, __]) {
    log.info("$runtimeType::modelArrived()");
  }

  void newGame() {
    log.info("$runtimeType::newGame()");

    hideBoard = true;

    // in case newGame() is called during a flip animation
    if (_animationTimer != null) {
      _animationTimer.cancel();
    }

    // delayed to allow the board-hiding to work
    async(() {
      _setBoardWidth();
      numPairs = (model.numCards / 2).floor();

      firstPick = null;
      secondPick = null;

      gameCards = new ObservableList.from(model.currentDeck.createGameDeck(numPairs));

      matchesNeeded = unmatchedPairs = numPairs;
      attempts = 0;
      win = false;

      hideBoard = false;
      interfaceEnabled = true;
    }, waitTime: 1);
  }

  @reflectable void cardRevealed(Event event, var detail) {
    Card card = (event.target as CardView).card;

    log.info("$runtimeType::cardFlipped() -- ${card}");

    if (firstPick == null) {
      firstPick = card;
    }
    else if (secondPick == null) {
      interfaceEnabled = false;
      attempts++;
      secondPick = card;

      // check for match
      if (firstPick.id == secondPick.id) {
        // delay this to allow animations to finish
        _animationTimer = new Timer(new Duration(seconds: 1), _matchMade);
      }
      else {
        // delay this to allow animations to finish
        _animationTimer = new Timer(new Duration(seconds: 2), _noMatchMade);
      }
    }
  }

  void _matchMade() {
    log.info("$runtimeType::_matchMade()");

    firstPick.match();
    secondPick.match();
    firstPick = secondPick = null;
    unmatchedPairs--;
    interfaceEnabled = true;

    // check for a win
    if (unmatchedPairs == 0) {
      log.info("Win!");

      interfaceEnabled = false;
      win = true;
      _unmatchAll();
    }
  }

  void _noMatchMade() {
    log.info("$runtimeType::_noMatchMade()");

    firstPick.flip();
    secondPick.flip();
    firstPick = secondPick = null;
    interfaceEnabled = true;
  }

  void _unmatchAll() {
    gameCards.forEach((Card card) => card.match());
  }

  void _setBoardWidth() {
    String boardWidthAttribute;
    var wrapper = Polymer.dom($['wrapper']);

    wrapper
      ..removeAttribute("row2")
      ..removeAttribute("row3")
      ..removeAttribute("row4");

    if (model.numCards > 4 && model.numCards % 4 == 0) {
      boardWidthAttribute = "row4";
    }
    else if (model.numCards % 3 == 0) {
      boardWidthAttribute = "row3";
    }
    else if (model.numCards % 2 == 0) {
      boardWidthAttribute = "row2";
    }

    wrapper.setAttribute(boardWidthAttribute, true);
  }
}

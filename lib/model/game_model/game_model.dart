@HtmlImport('game_model.html')
library remember_me.lib.model.game_model;

import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import '../../services/logger.dart';
import '../../model/deck.dart';

@PolymerRegister('game-model')
class GameModel extends PolymerElement with AutonotifyBehavior, Observable {

  @observable @property Deck currentDeck;
  @observable @property int numCards;   // difficulty is determined by how many cards are used in a game

  GameModel.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready()");
  }
}
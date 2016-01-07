@HtmlImport('card_view.html')
library remember_me.lib.views.card_view;

import 'dart:html';

import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import '../../services/logger.dart';
import '../../model/card.dart';

@PolymerRegister('card-view')
class CardView extends PolymerElement with AutonotifyBehavior, Observable {

  @observable @property Card card;
  @property bool interfaceEnabled = true;

  CardView.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready() -- $card");
  }

  @reflectable void reveal(Event event, var detail) {
    log.info("$runtimeType::reveal() -- $card");

    if (interfaceEnabled && !card.flipped) {
      card.flip();
      fire("card-revealed");
    }
  }
}


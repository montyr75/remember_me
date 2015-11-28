@HtmlImport('card_view.html')
library remember_me.lib.views.card_view;

import 'dart:html';
import '../../model/global.dart';
import '../../model/cards.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('card-view')
class CardView extends PolymerElement {

  @property Card card;
  @property bool interfaceEnabled = true;

  CardView.created() : super.created();

  void ready() {
    log.info("$runtimeType::ready() -- $card");
  }

  @reflectable void reveal(Event event, var detail) {
    log.info("$runtimeType::reveal() -- $card");

    if (interfaceEnabled && !card.flipped) {
      flip();
      fire("card-flipped");
    }
  }

  void flip() => set('card.flipped', !card.flipped);
  void match() => set('card.matched', !card.matched);
}


library card_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../model/cards.dart';

@CustomTag('card-view')
class CardView extends PolymerElement {

  @published Card card;
  @published String baseImagePath;
  @published String backImageURL;
  @published bool interfaceEnabled;

  @observable String imageURL;

  CardView.created() : super.created();

  @override void attached() {
    super.attached();
//    print("CardView::attached()");

    imageURL = "${baseImagePath}${card.imageFilename}";
  }

  void flip(Event event, var detail, Element target) {
    print("CardView::flip() -- $card");

    if (!card.flipped && interfaceEnabled) {
      card.flip();
      fire("card-revealed", detail: card);
    }
  }
}


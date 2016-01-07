library remember_me.lib.model.card;

import "package:polymer_autonotify/polymer_autonotify.dart";
import "package:observe/observe.dart";
import 'package:polymer/polymer.dart';

class Card extends Observable {
  int id;
  @reflectable String title;
  String imageFilename;

  @reflectable String imageURL;
  @reflectable String backImageURL;

  @observable bool flipped = false;
  @observable bool matched = false;

  Card();

  Card.fromData(int this.id, String this.title, String this.imageFilename, String imagePath, String this.backImageURL) {
    imageURL = "$imagePath/$imageFilename";
  }

  Card.fromMap(int id, String imagePath, String backImageURL, Map map) : this.fromData(id, map["title"], map["imageFilename"], imagePath, backImageURL);

  bool flip() => flipped = !flipped;
  bool match() => matched = !matched;

  Card clone() => new Card()
      ..id = id
      ..title = title
      ..imageURL = imageURL
      ..backImageURL = backImageURL;

  @override String toString() => title;
}
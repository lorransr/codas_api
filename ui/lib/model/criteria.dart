import "dart:math";

import 'package:myanimate/model/criteria_type.dart';

class Criteria {
  String name;
  String key = "";
  CriteriaType type = CriteriaType.benefit;
  double weight;
  Criteria(this.name, this.type, this.weight) {
    this.key = getRandomString(10);
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

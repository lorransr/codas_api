import 'dart:convert';

import 'package:codas_method/model/model_results.dart';

class TableHelper {
  List<String> getAlternatives(ModelResults data) {
    return data.results.relativeAssessmentMatrix.keys.toList();
  }

  List<List<dynamic>> getMatrixArray(
      Map<String, dynamic> matrix, List<String> _alternatives) {
    var _matrix = matrix;
    Map<String, List<dynamic>> parsedMatrix = {};
    _matrix.keys.toList().forEach((element) {
      var _values = List<dynamic>.from(_matrix[element].values);
      print(_values);
      parsedMatrix[element] = _values;
    });

    parsedMatrix["0_alternatives"] = _alternatives;
    var _keys = parsedMatrix.keys.toList();
    _keys.sort();

    List<List<dynamic>> _matrixArray = [];
    _matrixArray.add(_keys.map((e) {
      if (e == "0_alternatives") {
        return "alternatives";
      } else {
        return e;
      }
    }).toList());

    for (var idx = 0; idx < _alternatives.length; idx += 1) {
      var _array = [];
      _keys.forEach((k) {
        print(k);
        print(idx);
        print(parsedMatrix[k]);
        _array.add(parsedMatrix[k][idx]);
      });
      _matrixArray.add(_array);
    }
    return _matrixArray;
  }
}

import 'package:codas_method/model/model_results.dart';

class TableHelper {
  List<String> getAlternatives(ModelResults data) {
    return data.results.relativeAssessmentMatrix.keys.toList();
  }

  List<List<dynamic>> getVectorArray(Map<String, dynamic> vector) {
    var columns = vector.keys.toList();
    var values = vector.values.toList();
    return [columns, values];
  }

  List<List<dynamic>> getDistanceArray(
      Map<String, dynamic> vector, List<String> _alternatives,
      {useIndex = false}) {
    List<List<dynamic>> _vectorArray = [];
    _vectorArray.add(["alternatives", "value"]);
    var _values = vector.values.toList();
    for (var idx = 0; idx < _alternatives.length; idx += 1) {
      String _alternative;
      if (useIndex == true) {
        _alternative = vector.keys.toList()[idx];
      } else {
        _alternative = _alternatives[idx];
      }
      var _value = double.parse(_values[idx].toString()).toStringAsFixed(3);
      _vectorArray.add([_alternative, _value]);
      print(_vectorArray[idx]);
    }
    return _vectorArray;
  }

  List<List<dynamic>> getComparrisonMatrixArray(
      Map<String, dynamic> matrix, List<String> _alternatives) {
    List<List<dynamic>> _matrixArray = [];
    var _cols = [""];
    _cols.addAll(matrix.keys.toList());

    _matrixArray.add(_cols);

    matrix.forEach((key, value) {
      var _row = [];
      _row.add(key);
      var _v = Map<String, dynamic>.from(value);
      _v.forEach((k, v) {
        _row.add(double.parse(v.toString()).toStringAsFixed(3));
      });
      _matrixArray.add(_row);
    });
    return _matrixArray;
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
      List<String> _array = [];
      _keys.forEach((k) {
        print("k: $k");
        print("idx: $idx");
        var value = parsedMatrix[k][idx];
        print("value: $value");
        if (k != "0_alternatives") {
          var valueTransformed = value.toStringAsFixed(3);
          _array.add(valueTransformed);
        } else {
          _array.add(value);
        }
      });
      _matrixArray.add(_array);
    }
    return _matrixArray;
  }
}

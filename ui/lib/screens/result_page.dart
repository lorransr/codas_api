import 'dart:convert';

import 'package:codas_method/helpers/table_helper.dart';
import 'package:codas_method/model/criteria.dart';
import 'package:codas_method/model/criteria_type.dart';
import 'package:codas_method/provider/pdf_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:codas_method/bloc/results_bloc.dart';
import 'package:codas_method/model/codas_input.dart';
import 'package:codas_method/model/model_results.dart';
import 'package:flutter/rendering.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/results';
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ScrollController _controller;
  var _pdfProvider = PDFProvider();
  var _tableHelper = TableHelper();
  @override
  Widget build(BuildContext context) {
    _controller = ScrollController();
    CodasInput _input = ModalRoute.of(context).settings.arguments;
    if (_input != null) {
      print("received inputs: ${_input}");
    } else {
      print("empty arguments; generating inputs...");
      List<Criteria> _fakeCriterias = [
        Criteria("criteria_1", CriteriaType.benefit, 0.5),
        Criteria("criteria_2", CriteriaType.benefit, 0.5)
      ];
      List<List<double>> _fakeAlternatives = [
        // [0.1, 0.3],
        // [0.5473, 0.5],
        // [0.2, 0.1],
        // [0.7, 0.1],
        // [0.4, 0.2],
        // [1, 0.3],
        // [0.4, 1]
        [0.1, 0.3444],
        [0.5473, 0.5],
        [0.222, 0.1],
        [0.777, 0.1],
        [0.4444, 0.222],
        [1, 0.333],
        [0.4555, 1]
      ];

      List<String> _fakeAlternativesNames = [
        "alternative 1",
        "alternative 2",
        "alternative 3",
        "alternative 4",
        "alternative 5",
        "alternative 6",
        "alternative 7",
      ];
      _input = CodasInput(
          _fakeCriterias, _fakeAlternatives, _fakeAlternativesNames, 0.02);
    }
    print("input: ${jsonEncode(_input)}");
    resultsBloc.getRanking(_input);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          SizedBox(height: 32),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _controller,
              child: SingleChildScrollView(
                controller: _controller,
                child: StreamBuilder<ModelResults>(
                  stream: resultsBloc.subject.stream,
                  builder: (context, AsyncSnapshot<ModelResults> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.error != null &&
                          snapshot.data.error.length > 0) {
                        return _buildErrorWidget(snapshot.data.error);
                      }
                      return _buildSuccessWidget(snapshot.data);
                    } else if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error);
                    } else {
                      return _buildLoadingWidget();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading data from API..."),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error"),
        ],
      ),
    );
  }

  Widget _assessmetScoreTile(ModelResults data) {
    print("data: ${data.results.toJson()}");
    return ListTile(
      title: Text(
        "✨ Assessment Score ✨",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          child: DataTable(columns: [
            DataColumn(label: Text("Ranking")),
            DataColumn(label: Text("Alternative")),
            DataColumn(label: Text("Value"))
          ], rows: _getRowsFromResults(data.results.assessmentScore)),
        ),
      ),
    );
  }

  Widget _simpleMatrixTile(Map<String, dynamic> simpleMatrix) {
    List<DataColumn> _cols = [];
    List<DataRow> _rows = [];
    List<DataCell> _cells = [];
    simpleMatrix.keys.forEach((column) {
      _cols.add(DataColumn(label: Text(column)));
      _cells.add(DataCell(Text(simpleMatrix[column].toStringAsFixed(3))));
    });
    _rows.add(DataRow(cells: _cells));
    return DataTable(columns: _cols, rows: _rows);
  }

  Widget _matrixTile(Map<String, dynamic> matrix, {List<String> alternatives}) {
    print("Matrix: ${matrix.entries}");
    List<DataColumn> _cols = [];
    _cols.add(DataColumn(label: Text("Alternative")));
    matrix.keys.forEach(
      (element) {
        _cols.add(
          DataColumn(label: Text(element)),
        );
      },
    );
    List<DataRow> _rows = [];
    int idx = 0;
    alternatives.forEach((a) {
      List<DataCell> _cells = [];
      var _alternativeCell = DataCell(Text(a));
      _cells.add(_alternativeCell);
      matrix.keys.forEach((key) {
        var _cell = DataCell(Text(matrix[key]["$idx"].toStringAsFixed(3)));
        _cells.add(_cell);
      });
      idx += 1;
      _rows.add(DataRow(cells: _cells));
    });

    print("cols length: ${_cols.length}");
    print("rows length: ${_rows.length}");

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _cols,
        rows: _rows,
      ),
    );
  }

  Widget _relativeAssessmentMatrixTile(Map<String, dynamic> matrix) {
    List<DataColumn> _cols = [];
    print(matrix);
    _cols.add(DataColumn(label: Text("")));
    _cols.addAll(matrix.keys.map((e) => DataColumn(label: Text(e))));
    List<DataRow> _rows = [];
    matrix.forEach((k, v) {
      List<DataCell> _cells = [];
      _cells.add(DataCell(Text(k)));
      v.forEach(
        (key, value) {
          _cells.add(
            DataCell(
              Text(
                value.toStringAsFixed(3),
              ),
            ),
          );
        },
      );
      _rows.add(DataRow(cells: _cells));
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _cols,
        rows: _rows,
      ),
    );
  }

  Widget _distanceTile(
      Map<String, dynamic> vector, List<String> alternatives, String distance) {
    List<DataColumn> _cols = [
      DataColumn(label: Text("Alternatives")),
      DataColumn(label: Text(distance))
    ];
    List<DataRow> _rows = [];
    List<DataCell> _cells;
    int idx = 0;
    int maxLen = vector.length;
    print("maxLen: ${maxLen}");
    while (idx < maxLen) {
      _cells = [];
      _cells.add(DataCell(Text(alternatives[idx])));
      _cells.add(DataCell(Text(vector["$idx"].toStringAsFixed(3))));
      _rows.add(DataRow(cells: _cells));
      idx += 1;
    }
    return DataTable(
      columns: _cols,
      rows: _rows,
    );
  }

  Widget _buildSuccessWidget(ModelResults data) {
    List<String> _alternatives = _tableHelper.getAlternatives(data);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _assessmetScoreTile(data),
          Divider(),
          Text(
            "Method Outputs",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 32,
          ),
          ListTile(
            title: Text(
              "Normalized Matrix",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _matrixTile(data.results.normalizedMatrix,
                      alternatives: _alternatives)),
            ),
          ),
          ListTile(
            title: Text(
              "Weighted Matrix",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                child: _matrixTile(data.results.weightedMatrix,
                    alternatives: _alternatives),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Negative Ideal Solution",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _simpleMatrixTile(data.results.negativeIdealSolution)),
            ),
          ),
          ListTile(
            title: Text(
              "Euclidian Distance from the Negative Ideal Solution",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                  child: _distanceTile(data.results.euclidianDistance,
                      _alternatives, "distance")),
            ),
          ),
          ListTile(
            title: Text(
              "Manhathan Distance from the Negative Ideal Solution",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                child: _distanceTile(
                    data.results.manhathanDistance, _alternatives, "distance"),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Relative Assessment Matrix",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                child: _relativeAssessmentMatrixTile(
                    data.results.relativeAssessmentMatrix),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () => _pdfProvider.createPDF(data),
                child: Text("Print Results")),
          )
        ],
      ),
    );
  }

  List<DataRow> _getRowsFromResults(Map<String, dynamic> results) {
    List<DataRow> _dataRows = [];
    int ranking = 1;
    results.forEach((key, value) {
      var _value = value.toStringAsFixed(3);
      var _row = DataRow(
        cells: [
          DataCell(
            Text(
              ranking.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataCell(
            Text(key),
          ),
          DataCell(
            Text(_value),
          ),
        ],
      );
      _dataRows.add(_row);
      ranking += 1;
    });
    return _dataRows;
  }
}

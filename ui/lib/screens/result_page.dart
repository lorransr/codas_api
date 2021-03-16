import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:codas_method/bloc/results_bloc.dart';
import 'package:codas_method/model/codas_input.dart';
import 'package:codas_method/model/criteria.dart';
import 'package:codas_method/model/criteria_type.dart';
import 'package:codas_method/model/model_results.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/results';
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    CodasInput _input = ModalRoute.of(context).settings.arguments;
    // if (_input != null) {
    //   print("received inputs: ${_input}");
    // } else {
    //   print("empty arguments; generating inputs...");
    //   List<Criteria> _fakeCriterias = [
    //     Criteria("criteria_1", CriteriaType.benefit, 0.5),
    //     Criteria("criteria_2", CriteriaType.benefit, 0.5)
    //   ];
    //   List<List<double>> _fakeAlternatives = [
    //     [0.1, 0.3],
    //     [0.5473, 0.5],
    //     [0.2, 0.1],
    //     [0.7, 0.1],
    //     [0.4, 0.2],
    //     [1, 0.3],
    //     [0.4, 1]
    //   ];
    //   _input = CodasInput(_fakeCriterias, _fakeAlternatives, 0.02);
    // }
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
            child: SingleChildScrollView(
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

  Widget _buildSuccessWidget(ModelResults data) {
    print("results: ${data.results}");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Results Table"),
          DataTable(
            columns: [
              DataColumn(label: Text("Alternative")),
              DataColumn(label: Text("Value"))
            ],
            rows: _getRowsFromResults(data.results),
          )
        ],
      ),
    );
  }

  List<DataRow> _getRowsFromResults(Map<String, dynamic> results) {
    List<DataRow> _dataRows = [];
    results.forEach((key, value) {
      var _value = value.toStringAsFixed(3);
      var _row = DataRow(cells: [
        DataCell(Text(key
            .toUpperCase()
            .replaceAll("A", "ALTERNATIVE")
            .replaceAll("_", " "))),
        DataCell(Text(_value))
      ]);
      _dataRows.add(_row);
    });
    return _dataRows;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myanimate/bloc/results_bloc.dart';
import 'package:myanimate/model/codas_input.dart';
import 'package:myanimate/model/criteria.dart';
import 'package:myanimate/model/criteria_type.dart';
import 'package:myanimate/model/model_results.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/results';
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
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
        [0.1, 0.3],
        [0.5473, 0.5],
        [0.2, 0.1],
        [0.7, 0.1],
        [0.4, 0.2],
        [1, 0.3],
        [0.4, 1]
      ];
      _input = CodasInput(_fakeCriterias, _fakeAlternatives, 0.02);
    }
    print("input: ${jsonEncode(_input)}");
    resultsBloc.getRanking(_input);
    // TODO: implement build
    return StreamBuilder<ModelResults>(
      stream: resultsBloc.subject.stream,
      builder: (context, AsyncSnapshot<ModelResults> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildSuccessWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Results widget"),
        ],
      ),
    );
  }
}

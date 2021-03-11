import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myanimate/bloc/results_bloc.dart';
import 'package:myanimate/model/codas_input.dart';
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
    print("input: ${_input.toJson()}");
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

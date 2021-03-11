import 'package:myanimate/model/codas_input.dart';
import 'package:myanimate/model/model_results.dart';
import 'package:myanimate/repository/result_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResultsBloc {
  final _repository = ResultsRepository();
  final BehaviorSubject<ModelResults> _subject =
      BehaviorSubject<ModelResults>();

  getRanking(CodasInput input) async {
    ModelResults response = await _repository.getRanking(input);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ModelResults> get subject => _subject;
}

final resultsBloc = ResultsBloc();

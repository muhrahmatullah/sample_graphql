
import 'package:flutter/widgets.dart';
import 'package:pocwebview/graphql_op/response_wrapper.dart';
import 'package:pocwebview/models/repo.dart';
import 'package:pocwebview/repositories/main/main_repository.dart';

class MainProvider extends ChangeNotifier{
  MainProvider(this.repository);

  final MainRepository repository;

  ResponseWrapper<List<Repo>> repoResponse = ResponseWrapper.loading(
    data: [],
    error: false,
  );

  Future<void> fetchRepo() async {
    final result = await repository.fetchRepo();

    repoResponse = result;
    notifyListeners();
  }
}

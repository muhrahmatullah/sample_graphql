import 'package:flutter/cupertino.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pocwebview/graphql_op/queries/read_repo.dart';
import 'package:pocwebview/graphql_op/response_wrapper.dart';
import 'package:pocwebview/models/repo.dart';

class MainRepository {
  MainRepository({@required this.client}) : assert(client != null);

  final GraphQLClient client;

  Future<ResponseWrapper<List<Repo>>> fetchRepo() async {
    final WatchQueryOptions _options = WatchQueryOptions(
      documentNode: parseString(readRepositories),
      variables: <String, dynamic>{
        'nRepositories': 5,
      },
      pollInterval: 4,
      fetchResults: true,
    );

    QueryResult result = await client.query(_options);

    if (result.hasException) {
      return ResponseWrapper.error(message: result.exception.toString(), error: true, data: []);
    }

    final List<dynamic> raw = result.data['viewer']['repositories']['nodes'] as List<dynamic>;

    final List<Repo> listOfRepos = raw
        .map((dynamic e) => Repo(
              id: e['id'] as String,
              name: e['name'] as String,
              viewerHasStarred: e['viewerHasStarred'] as bool,
            ))
        .toList();

    return ResponseWrapper.success(message: '', data: listOfRepos);
  }
}

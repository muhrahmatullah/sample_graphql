import 'package:graphql_flutter/graphql_flutter.dart';

class ClGraphqlClient {
  GraphQLClient _graphQLClient;

  final OptimisticCache cache = OptimisticCache(
    dataIdFromObject: typenameDataIdFromObject,
  );

  GraphQLClient get graphQlClient => _graphQLClient;

  GraphQLClient init() {
    final HttpLink _httpLink = HttpLink(
      uri: 'https://api.github.com/graphql',
    );

    final AuthLink _authLink = AuthLink(
      // Put your github access token here
      // like this Bearer <Accees Token>
      getToken: () => 'Bearer ',
    );

    final Link _link = _authLink.concat(_httpLink);

    _graphQLClient = GraphQLClient(
      cache: cache,
      link: _link,
    );
    return _graphQLClient;
  }
}

class GraphQLException implements Exception {
  final String message;

  GraphQLException(this.message);

  @override
  String toString() => 'GraphQLException: $message';
}

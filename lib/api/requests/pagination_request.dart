class PaginationRequest {
  final int page;
  final int perPage;

  PaginationRequest({
    required this.page,
    required this.perPage,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'per_page': perPage,
      };

  String toQuery() {
    final query = <String>[];
    query.add('page=$page');
    query.add('per_page=$perPage');

    return "?${query.join('&')}";
  }
}

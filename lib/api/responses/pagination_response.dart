class PaginationResponse<T> {
  ListPaginationResponse? links;
  MetaPaginationResponse? meta;
  List<T>? data;

  PaginationResponse({
    this.links,
    this.meta,
    this.data,
  });

  factory PaginationResponse.fromJson(Map<String, dynamic> json,
      [T Function(Map<String, dynamic>)? fromJson]) {
    return PaginationResponse(
      links: ListPaginationResponse.fromJson(json['links']),
      meta: MetaPaginationResponse.fromJson(json['meta']),
      data: fromJson != null
          ? (json['data'] as List).map((e) {
            return fromJson(e);
          }).toList()
          : null,
    );
  }
}

class ListPaginationResponse {
  final String? first;
  final String? prev;
  final String? next;

  ListPaginationResponse({
    this.first,
    this.prev,
    this.next,
  });

  factory ListPaginationResponse.fromJson(Map<String, dynamic> json) {
    return ListPaginationResponse(
      first: json['first'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class MetaPaginationResponse {
  int? currentPage;
  int? from;
  String? path;
  String? perPage;
  int? to;
  MetaPaginationResponse({
    this.currentPage,
    this.from,
    this.path,
    this.perPage,
    this.to,
  });

  factory MetaPaginationResponse.fromJson(Map<String, dynamic> json) {
    return MetaPaginationResponse(
      currentPage: json['current_page'],
      from: json['from'],
      path: json['path'],
      perPage: json['per_page'].toString(),
      to: json['to'],
    );
  }
}

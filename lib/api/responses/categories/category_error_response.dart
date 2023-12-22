class CategoryErrorResponse {
  String name;
  
  CategoryErrorResponse({required this.name});

  factory CategoryErrorResponse.fromJson(Map<String, dynamic> json) {
    return CategoryErrorResponse(
      name: json['name'] == null ? '' : json['name'][0],
    );
  }
}

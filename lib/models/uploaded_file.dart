class UploadedFile {
  final int id;
  final String url;
  final String name;
  final String originalName;

  UploadedFile({
    required this.id,
    required this.url,
    required this.name,
    required this.originalName,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      originalName: json['original_name'],
    );
  }
}
class ResponsePage<T> {
  final List<T> content;
  final bool last;

  ResponsePage({required this.content, required this.last});

  factory ResponsePage.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return ResponsePage(
      content: (json['content'] as List).map((e) => fromJsonT(e)).toList(),
      last: json['last'] ?? true,
    );
  }
}
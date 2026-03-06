class ResponsePage<T> {
  final List<T> content;
  final bool last;
  final bool first;
  final int number;
  final int totalPages;
  final int totalElements;

  ResponsePage({
    required this.content,
    required this.last,
    required this.first,
    required this.number,
    required this.totalPages,
    required this.totalElements,
  });

  factory ResponsePage.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return ResponsePage(
      content: (json['content'] as List)
          .map((e) => fromJsonT(e))
          .toList(),

      last: json['last'] ?? true,
      first: json['first'] ?? false,
      number: json['number'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
    );
  }
}
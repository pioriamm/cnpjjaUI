class PageResponse<T> {
  final List<T> content;
  final bool last;
  final int number;
  final int totalPages;
  final int totalElements;

  PageResponse({
    required this.content,
    required this.last,
    required this.number,
    required this.totalPages,
    required this.totalElements,
  });

  factory PageResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PageResponse<T>(
      content: (json['content'] as List)
          .map((e) => fromJsonT(e))
          .toList(),
      last: json['last'],
      number: json['number'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
    );
  }
}
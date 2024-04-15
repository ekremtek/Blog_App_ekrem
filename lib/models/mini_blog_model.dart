class Blog {
  final String id;
  final String title;
  final String content;
  final String thumbnail;
  final String author;

  Blog(
      {required this.id,
      required this.title,
      required this.content,
      required this.thumbnail,
      required this.author});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      thumbnail: json['thumbnail'] as String,
      author: json['author'] as String,
    );
  }
}

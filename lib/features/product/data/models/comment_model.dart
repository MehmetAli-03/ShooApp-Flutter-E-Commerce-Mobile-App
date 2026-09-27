class CommentModel {
  final int id;
  final String userName;
  final int rating;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userName: json['userName'] ?? '',
      rating: json['rating'] is int ? json['rating'] : int.parse(json['rating'].toString()),
      text: json['text'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'rating': rating,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };
}
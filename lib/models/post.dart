class Post {
  final List<dynamic> county;

  Post({this.county});

  factory Post.fromJson(Map<dynamic, dynamic> json) {
    return Post(
      county: json['county'],
    );
  }
}

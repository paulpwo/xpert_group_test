class CatImage {
  final String id;
  final String url;
  final int width;
  final int height;

  CatImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
    };
  }
}

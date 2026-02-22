class PhotoModel {
  final int id;
  final String imageUrl; // The actual image link
  final String mediumUrl; // For faster grid loading
  final String photographer;
  final double aspectRatio; // CRUCIAL for the Masonry Grid

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.mediumUrl,
    required this.photographer,
    required this.aspectRatio,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    // Pexels returns width and height, we calculate aspect ratio for the UI
    final width = (json['width'] as num).toDouble();
    final height = (json['height'] as num).toDouble();

    return PhotoModel(
      id: json['id'],
      imageUrl: json['src']['large2x'], // High quality for detail view
      mediumUrl: json['src']['medium'], // Lower quality for grid performance
      photographer: json['photographer'],
      aspectRatio: width / height,
    );
  }
}
class DetailRestaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final String address;

  DetailRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.address,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'];
    return DetailRestaurant(
      id: restaurant['id'] ?? "",
      name: restaurant['name'] ?? "",
      description: restaurant['description'] ?? "",
      city: restaurant['city'] ?? "",
      address: restaurant['address'] ?? "",
      pictureId: restaurant['pictureId'] ?? "",
      rating: (restaurant['rating'] ?? 0).toDouble(),
    );
  }
}

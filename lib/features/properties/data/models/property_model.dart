class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final String address;
  final String city;
  final String state;
  final String country;
  final List<String> images;
  final List<String> amenities;
  final String status;
  final bool isActive;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.images,
    required this.amenities,
    required this.status,
    required this.isActive,
    required this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      price: double.parse(json['price'].toString()),
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      status: json['status'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

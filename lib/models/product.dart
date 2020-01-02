import 'package:hello_world/models/location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String imagePath;
  final String userEmail;
  final String userId;
  final LocationData location;
  final bool isFavorite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.image,
      this.imagePath,
      this.userEmail, 
      this.userId,
      this.location,
      this.isFavorite = false});
}

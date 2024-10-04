import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id; // Add the ID field
  String name;
  String imageUrl;
  double price;
  String category;
  String quantity;
  String branch;

  Product({
    required this.id, // Include the ID
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.quantity,
    required this.branch,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Add the ID to the map
      'p_name': name,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'p_quantity': quantity,
      'branch': branch,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '', // Get the ID from the map
      name: map['p_name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      quantity: map['p_quantity'] ?? '',
      branch: map['branch'] ?? '',
    );
  }

  static fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc, param1) {}
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String image;
  final bool isFavorite;

  Product({
    required this.id,
    required this.image,
    required this.isFavorite,
    required this.title,
  });

  factory Product.fromJson(QueryDocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Product(
      id: snap.id,
      image: data['image'],
      isFavorite: data['isFavorite'],
      title: data['title'],
    );
  }
}

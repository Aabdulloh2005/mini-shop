import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_shop/models/product.dart';

class FirebaseHttpService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection("products");

  Future<QuerySnapshot> getProducts() async {
    return await _productsCollection.get();
  }

  Future<void> addProduct(Product product) async {
    await _productsCollection.add({
      'image': product.image,
      'isFavorite': product.isFavorite,
      'title': product.title,
    });
  }

  Future<void> editProduct(Product product) async {
    await _productsCollection.doc(product.id).update({
      'image': product.image,
      'isFavorite': product.isFavorite,
      'title': product.title,
    });
  }

  Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }
}

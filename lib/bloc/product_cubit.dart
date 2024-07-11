import 'package:bloc/bloc.dart';
import 'package:mini_shop/bloc/product_state.dart';
import 'package:mini_shop/models/product.dart';
import 'package:mini_shop/services/firebase_http_service.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(LoadingState());
  List<Product> products = [];
  final FirebaseHttpService _firebaseHttpService = FirebaseHttpService();

  void getProducts() async {
    try {
      emit(LoadingState());
      final querySnapshot = await _firebaseHttpService.getProducts();
      products =
          querySnapshot.docs.map((doc) => Product.fromJson(doc)).toList();
      emit(LoadedState(products: products));
    } catch (e) {
      emit(ErrorState(error: "Error fetching products"));
      print(e);
    }
  }

  void addProduct(Product product) async {
    try {
      await _firebaseHttpService.addProduct(product);
      products.add(product);
      emit(LoadedState(products: products));
    } catch (e) {
      emit(ErrorState(error: "Error adding product"));
      print(e);
    }
  }

  void editProduct(Product product) async {
    try {
      await _firebaseHttpService.editProduct(product);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        emit(LoadedState(products: products));
      }
    } catch (e) {
      emit(ErrorState(error: "Error editing product"));
      print(e);
    }
  }

  void deleteProduct(String id) async {
    try {
      await _firebaseHttpService.deleteProduct(id);
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products.removeWhere(
          (element) {
            return element.id == id;
          },
        );
        emit(LoadedState(products: products));
      }
    } catch (e) {
      emit(ErrorState(error: "Error editing deleting"));
      print(e);
    }
  }
}

import 'package:mini_shop/models/product.dart';

abstract class ProductState {}

class InitialState extends ProductState {}

class LoadingState extends ProductState {}

class LoadedState extends ProductState {
  final List<Product> products;
  LoadedState({required this.products});
}

class ErrorState extends ProductState {
  final String error;
  ErrorState({required this.error});
}

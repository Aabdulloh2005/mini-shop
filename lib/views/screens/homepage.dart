import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_shop/bloc/product_cubit.dart';
import 'package:mini_shop/bloc/product_state.dart';
import 'package:mini_shop/models/product.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ProductCubit>().getProducts();
    });
  }

  void _showProductDialog({Product? product}) {
    final isEditing = product != null;
    final TextEditingController titleController =
        TextEditingController(text: isEditing ? product.title : '');
    final TextEditingController imageController =
        TextEditingController(text: isEditing ? product.image : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit Product" : "Add Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newProduct = Product(
                id: isEditing
                    ? product.id
                    : DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                image: imageController.text,
                isFavorite: isEditing ? product.isFavorite : false,
              );
              if (isEditing) {
                context.read<ProductCubit>().editProduct(newProduct);
              } else {
                context.read<ProductCubit>().addProduct(newProduct);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini shop"),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(child: Text(state.error));
          } else if (state is LoadedState) {
            final products = state.products;
            return GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                crossAxisCount: 2,
                mainAxisExtent: 200,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onDoubleTap: () {
                    context.read<ProductCubit>().deleteProduct(product.id);
                  },
                  onLongPress: () => _showProductDialog(product: product),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        height: 150,
                        child: product.image.startsWith("https")
                            ? Image.network(product.image, fit: BoxFit.cover)
                            : const Icon(Icons.image_outlined,
                                size: 60, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Text(product.title),
                          IconButton(
                            onPressed: () {
                              final updatedProduct = Product(
                                id: product.id,
                                title: product.title,
                                image: product.image,
                                isFavorite: !product.isFavorite,
                              );
                              context
                                  .read<ProductCubit>()
                                  .editProduct(updatedProduct);
                            },
                            icon: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color:
                                  product.isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No products loaded"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

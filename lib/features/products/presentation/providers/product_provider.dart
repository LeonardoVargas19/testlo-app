import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productRepositories = ref.watch(productRepositoryProvider);

  return ProductNotifier(
      productRepositories: productRepositories, productId: productId);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepositories productRepositories;

  ProductNotifier(
      {required this.productRepositories, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }

  Product newEmptyProduct(){
    return Product(
      id: 'new', 
      title: '', 
      price: 0, 
      description: '', 
      slug: '', 
      stock: 0, 
      sizes: [], 
      gender: 'men', 
      tags: [], 
      images: [], 
      );
  }

  Future<void> loadProduct() async {
    try {
      if(state.id == 'new'){
       state = state.copyWith(
          isLoading:false,
          produc: newEmptyProduct()
        );
        return;
      }


      final product = await productRepositories.getProductById(state.id);
      state = state.copyWith(isLoading: false, produc: product);
    } catch (e) {
      print(e);
    }
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});

  ProductState copyWith({
    String? id,
    Product? produc,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
          id: id ?? this.id,
          product: produc ?? this.product,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}

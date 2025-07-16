import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repositories_provider.dart';

//Provider
final prouductsProvider =
    StateNotifierProvider<ProducsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productRepositoryProvider);

  return ProducsNotifier(productRepositories: productsRepository);
});

//Notifier
class ProducsNotifier extends StateNotifier<ProductsState> {
  final ProductRepositories productRepositories;
  ProducsNotifier({required this.productRepositories})
      : super(ProductsState()) {
    loadNextPage();
  }
  Future<bool> createOrUpdateProduct(Map<String, dynamic > productLike) async{
      try {
        final product = await productRepositories.createProduct(productLike);
        final isProduct = state.product.any((element) => element.id == product.id);
        if(!isProduct){
          state = state.copyWith(
            product: [...state.product,product]
          );
          return true;
        }

        state = state.copyWith(
          product: state.product.map(
            (e) => (e.id == product.id) ? product : e ,
          ).toList()
        );
        return true;
      } catch (e) {

        return false;
      }
  }



  Future loadNextPage() async {
    if (state.isLoading || state.isLastPages) return;
    state = state.copyWith(isLoading: true);

    final product = await productRepositories.getProductsByPages(
        limit: state.limit, offset: state.offset);

    if (product.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPages: true);
      return;
    }
    state = state.copyWith(
        isLastPages: false,
        isLoading: false,
        offset: state.offset + 10,
        product: [...state.product, ...product]);
  }
}

//STATE
class ProductsState {
  final bool isLastPages;
  final int limit;
  final bool isLoading;
  final int offset;
  final List<Product> product;

  ProductsState(
      {this.isLastPages = false,
      this.limit = 10,
      this.isLoading = false,
      this.offset = 0,
      this.product = const []});

  ProductsState copyWith({
    bool? isLastPages,
    int? limit,
    bool? isLoading,
    int? offset,
    List<Product>? product,
  }) =>
      ProductsState(
        isLastPages: isLastPages ?? this.isLastPages,
        limit: limit ?? this.limit,
        isLoading: isLoading ?? this.isLastPages,
        offset: offset ?? this.offset,
        product: product ?? this.product,
      );
}

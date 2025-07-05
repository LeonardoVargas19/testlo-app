import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';

//Notifier
class ProducsNotifier extends StateNotifier<ProductsState> {
  final ProductRepositories productRepositories;
  ProducsNotifier({required this.productRepositories})
      : super(ProductsState()) {
    loadNextPage();
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

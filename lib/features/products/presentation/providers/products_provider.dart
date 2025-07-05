import 'package:teslo_shop/features/products/domain/domian.dart';

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

  ProductsState copyWith(
    bool? isLastPages,
    int? limit,
    bool? isLoading,
    int? offset,
    List<Product>? product,
  ) =>
      ProductsState(
        isLastPages: isLastPages ?? this.isLastPages,
        limit: limit ?? this.limit,
        isLoading: isLoading ?? this.isLastPages,
        offset: offset ?? this.offset,
        product: product ?? this.product,
      );
}

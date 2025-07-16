import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/const/environment.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/shared/infrastructions/inputs/inputs.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProducFormState, Product>((ref, product) {
  //  final createUpdateCallback = ref.watch(productRepositoryProvider).createProduct;
  final createUpdateCallback =
      ref.watch(prouductsProvider.notifier).createOrUpdateProduct;
  return ProductFormNotifier(
      produc: product, onSumintCallback: createUpdateCallback);
});

class ProductFormNotifier extends StateNotifier<ProducFormState> {
  final Future<bool> Function(Map<String, dynamic> producLike)?
      onSumintCallback;

  ProductFormNotifier({
    this.onSumintCallback,
    required Product produc,
  }) : super(ProducFormState(
            id: produc.id,
            title: Title.dirty(produc.title),
            slug: Slug.dirty(produc.slug),
            price: Price.dirty(produc.price),
            inStock: Stock.dirty(produc.stock),
            size: produc.sizes,
            gender: produc.gender,
            description: produc.description,
            tags: produc.tags.join(', '),
            images: produc.images));

  void onTitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isValid: Formz.validate([
          Slug.dirty(value),
          Title.dirty(state.title.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isValid: Formz.validate([
          Price.dirty(value),
          Slug.dirty(state.slug.value),
          Title.dirty(state.title.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onStockChanged(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isValid: Formz.validate([
          Stock.dirty(value),
          Price.dirty(state.price.value),
          Slug.dirty(state.slug.value),
          Title.dirty(state.title.value),
        ]));
  }

  void onSizeChange(List<String> sizes) {
    state = state.copyWith(size: sizes);
  }

  void onGenderChange(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescChange(String description) {
    state = state.copyWith(description: description);
  }

  void onTagChange(String tags) {
    state = state.copyWith(tags: tags);
  }

  void _touchEverything() {
    state = state.copyWith(
        isValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  Future<bool> onFormSumit() async {
    _touchEverything();

    if (!state.isValid) return false;

    if (onSumintCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.size,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map((images) =>
              images.replaceAll('${Environment.apiUrl}/files/product', ''))
          .toList()
    };

    try {
      await onSumintCallback!(productLike);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class ProducFormState {
  final bool isValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> size;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProducFormState(
      {this.isValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.size = const [],
      this.gender = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});
  ProducFormState copyWith({
    bool? isValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? size,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProducFormState(
          isValid: isValid ?? this.isValid,
          id: id ?? this.id,
          title: title ?? this.title,
          slug: slug ?? this.slug,
          price: price ?? this.price,
          size: size ?? this.size,
          gender: gender ?? this.gender,
          inStock: inStock ?? this.inStock,
          description: description ?? this.description,
          tags: tags ?? this.tags,
          images: images ?? this.images);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/repositories/product_repositories.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

final productRepositoryProvider = Provider<ProductRepositories>((ref) {
  final accesToken = ref.watch(authProvider).user?.token ?? '';
  final productsRepositories =
      ProductsRepositoriesImp(ProductDatasourceImpl(accesToken: accesToken));
  return productsRepositories;
});

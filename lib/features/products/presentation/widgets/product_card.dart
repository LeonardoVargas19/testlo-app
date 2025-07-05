import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';

class ProductsCard extends StatelessWidget {
  final Product product;
  const ProductsCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImagesViewer(
          imagen: product.images,
        ),
        Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _ImagesViewer extends StatelessWidget {
  final List<String> imagen;
  const _ImagesViewer({required this.imagen});

  @override
  Widget build(BuildContext context) {
    if (imagen.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 250,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: NetworkImage(imagen.first),
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
      ),
    );
  }
}

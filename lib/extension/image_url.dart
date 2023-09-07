import 'package:flutter/material.dart';

import 'ShimmerText.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit boxfit;

  const NetworkImageWithPlaceholder(
      {super.key,
      required this.imageUrl,
      required this.width,
      required this.height,
      required this.boxfit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: boxfit,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const Center(
                child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: ShimmerBox(),
            ));
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}

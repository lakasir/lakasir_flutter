import 'dart:io';

import 'package:flutter/material.dart';

class BuildListImage extends StatelessWidget {
  final String? url;
  const BuildListImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return SizedBox(
        height: 90,
        width: 90,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/no-image-100.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Check if it's a local file path
    if (url!.startsWith('/') || url!.startsWith('file://')) {
      final String filePath = url!.replaceAll('file://', '');
      return SizedBox(
        height: 90,
        width: 90,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                'assets/no-image-100.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    }

    // Network image
    return SizedBox(
      height: 90,
      width: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url!,
          fit: BoxFit.cover,
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset(
              'assets/no-image-100.png',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
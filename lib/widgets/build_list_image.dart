import 'package:flutter/material.dart';

class BuildListImage extends StatelessWidget {
  final String? url;
  const BuildListImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: url != null
            ? Image.network(
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
              )
            : Image.asset(
                'assets/no-image-100.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

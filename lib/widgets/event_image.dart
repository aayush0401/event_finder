import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  const EventImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl.trim().isEmpty
            ? const _ImagePlaceholder()
            : Image.network(
                imageUrl,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const _ImagePlaceholder(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (_, error, stackTrace) {
                  return const _ImagePlaceholder();
                },
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final Widget child;

  const _ImagePlaceholder({
    this.child = const Icon(Icons.image_not_supported_outlined),
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE5E7EB),
      child: Center(child: child),
    );
  }
}

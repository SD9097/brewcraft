import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'local_file_image.dart';

class HybridImage extends StatelessWidget {
  const HybridImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final child = _buildImage(context);
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _buildImage(BuildContext context) {
    if (path == null || path!.isEmpty) return _placeholder(context);
    if (path!.startsWith('assets/')) {
      return Image.asset(
        path!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    }
    if (path!.startsWith('blob:')) {
      return Image.network(
        path!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    }
    if (path!.startsWith('http://') || path!.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: path!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => _placeholder(context),
        errorWidget: (_, __, ___) => _placeholder(context),
      );
    }
    if (kIsWeb) return _placeholder(context);
    return LocalFileImage(
      path: path!,
      width: width,
      height: height,
      fit: fit,
      placeholder: _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Icon(
        Icons.image_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

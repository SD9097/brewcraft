import 'package:flutter/material.dart';

class LocalFileImage extends StatelessWidget {
  const LocalFileImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    required this.placeholder,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) => placeholder;
}

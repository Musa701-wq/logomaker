import 'dart:io';
import 'package:flutter/material.dart';
import '../services/cache_service.dart';
import 'shimmer_loading.dart';

class CachedImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const CachedImage(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _checkCache();
  }

  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _localPath = null;
      _checkCache();
    }
  }

  void _checkCache() async {
    final cache = CacheService.instance;
    final path = await cache.getLocalPath(widget.url);
    if (path != null && File(path).existsSync()) {
      if (mounted) setState(() => _localPath = path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_localPath != null) {
      return Image.file(
        File(_localPath!),
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        errorBuilder: widget.errorBuilder,
      );
    }
    return Image.network(
      widget.url,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: widget.errorBuilder,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          _cacheInBg();
          return child;
        }
        return ShimmerLoading(
          width: widget.width,
          height: widget.height,
          borderRadius: 8,
        );
      },
    );
  }

  void _cacheInBg() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CacheService.instance.cacheImage(widget.url);
    });
  }
}

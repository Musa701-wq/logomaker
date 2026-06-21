import 'dart:io';
import 'package:flutter/material.dart';
import '../services/cache_service.dart';

/// In-memory cache so we never hit the DB twice for the same URL
/// (survives hot reload but cleared on cold restart — acceptable)
final _memCache = <String, String>{};

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
  // null  = still checking
  // ''    = not cached, use network
  // path  = cached file path
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _localPath = null;
      _resolve();
    }
  }

  void _resolve() {
    // 1. Check in-memory cache first (instant, synchronous)
    final mem = _memCache[widget.url];
    if (mem != null) {
      // Already resolved before — set immediately, no setState needed
      _localPath = mem;
      return;
    }

    // 2. Hit the DB (async, one-time per URL per session)
    _checkCache();
  }

  Future<void> _checkCache() async {
    final cache = CacheService.instance;
    final path = await cache.getLocalPath(widget.url);
    if (path != null && File(path).existsSync()) {
      _memCache[widget.url] = path; // store in memory
      if (mounted) setState(() => _localPath = path);
    } else {
      _memCache[widget.url] = ''; // mark as "not on disk"
      if (mounted) setState(() => _localPath = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Still resolving cache — show nothing (avoids flicker/circle flash)
    if (_localPath == null) {
      return SizedBox(width: widget.width, height: widget.height);
    }

    // Cached on disk — load instantly with fade-in
    if (_localPath!.isNotEmpty) {
      return _FadeIn(
        child: Image.file(
          File(_localPath!),
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: widget.errorBuilder,
        ),
      );
    }

    // Not cached — load from network with smooth loading + cache in bg
    return Image.network(
      widget.url,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: widget.errorBuilder,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          _cacheInBg();
          return _FadeIn(child: child);
        }
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFBDBDBD),
              ),
            ),
          ),
        );
      },
    );
  }

  void _cacheInBg() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final path = await CacheService.instance.cacheImage(widget.url);
      if (path.isNotEmpty) {
        _memCache[widget.url] = path; // update memory cache
      }
    });
  }
}

/// Simple fade-in wrapper for smooth appearance
class _FadeIn extends StatefulWidget {
  final Widget child;
  const _FadeIn({required this.child});

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _anim, child: widget.child);
}

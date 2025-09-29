import 'package:flutter/material.dart';

typedef OverflowBuilder =
    Widget Function(bool isOverflowing, double childWidth, double maxWidth);

class OverflowDetector extends StatefulWidget {
  const OverflowDetector({
    super.key,
    required this.child,
    required this.maxWidth,
    required this.onOverflow,
  });

  final Widget child;
  final double maxWidth;
  final OverflowBuilder onOverflow;

  @override
  State<OverflowDetector> createState() => _OverflowDetectorState();
}

class _OverflowDetectorState extends State<OverflowDetector> {
  final GlobalKey _childKey = GlobalKey();
  double _childWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final context = _childKey.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        setState(() {
          _childWidth = box.size.width;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverflowing = _childWidth > widget.maxWidth;
    return Stack(
      children: [
        Opacity(
          opacity: 0.0,
          child: KeyedSubtree(key: _childKey, child: widget.child),
        ),
        widget.onOverflow(isOverflowing, _childWidth, widget.maxWidth),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant OverflowDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child ||
        oldWidget.maxWidth != widget.maxWidth) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    }
  }
}

import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
      builder: (context, child) {
        final position = (_controller.value * 2) - 1;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + position, 0),
              end: Alignment(1 + position, 0),
              colors: const <Color>[
                Color(0xFFE2E8F0),
                Color(0xFFF8FAFC),
                Color(0xFFE2E8F0),
              ],
              stops: const <double>[0.2, 0.5, 0.8],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class SkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated.withOpacity(_animation.value)
                : AppColors.lightBorder.withOpacity(_animation.value),
            borderRadius: widget.borderRadius ?? AppRadius.brMd,
          ),
        );
      },
    );
  }
}

class WeatherSkeletonView extends StatelessWidget {
  const WeatherSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 180, borderRadius: AppRadius.brXl),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 110)),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 110)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 110)),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 110)),
            ],
          ),
          SizedBox(height: 20),
          SkeletonBox(height: 140, borderRadius: AppRadius.brXl),
        ],
      ),
    );
  }
}

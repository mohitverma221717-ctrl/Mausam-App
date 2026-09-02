import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum LiveClockStyle {
  pill,
  inlineText,
}

class LiveClockWidget extends StatefulWidget {
  final LiveClockStyle style;
  final bool showDate;
  final bool showSeconds;

  const LiveClockWidget({
    super.key,
    this.style = LiveClockStyle.pill,
    this.showDate = false,
    this.showSeconds = false,
  });

  @override
  State<LiveClockWidget> createState() => _LiveClockWidgetState();
}

class _LiveClockWidgetState extends State<LiveClockWidget>
    with WidgetsBindingObserver {
  Timer? _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      final now = DateTime.now();
      if (now.second != _currentTime.second ||
          now.minute != _currentTime.minute ||
          now.hour != _currentTime.hour ||
          now.day != _currentTime.day) {
        setState(() {
          _currentTime = now;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
      _startTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeFormat = widget.showSeconds ? 'hh:mm:ss a' : 'hh:mm a';
    final timeStr = DateFormat(timeFormat).format(_currentTime);
    final dateStr = DateFormat('EEE, d MMM').format(_currentTime);

    if (widget.style == LiveClockStyle.inlineText) {
      return Text(
        widget.showDate ? '$dateStr · $timeStr' : timeStr,
        style: AppTypography.bodySmall.copyWith(
          color: isDark
              ? AppColors.textDarkMuted
              : AppColors.textLightMuted,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceCard
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.accentCyan : const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.showDate ? '$dateStr · $timeStr' : timeStr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
              color: isDark
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

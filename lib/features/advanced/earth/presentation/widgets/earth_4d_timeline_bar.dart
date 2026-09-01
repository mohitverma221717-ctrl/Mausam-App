import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';

class Earth4dTimelineBar extends StatefulWidget {
  final int selectedHourOffset;
  final ValueChanged<int> onOffsetChanged;
  final bool isPlaying;
  final ValueChanged<bool> onPlayPauseToggled;

  const Earth4dTimelineBar({
    super.key,
    required this.selectedHourOffset,
    required this.onOffsetChanged,
    required this.isPlaying,
    required this.onPlayPauseToggled,
  });

  static const List<int> timelineOffsets = [0, 1, 3, 6, 12, 24, 48, 72];

  @override
  State<Earth4dTimelineBar> createState() => _Earth4dTimelineBarState();
}

class _Earth4dTimelineBarState extends State<Earth4dTimelineBar> {
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isPlaying) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(Earth4dTimelineBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer();
    _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 1600), (_) {
      final currentIndex =
          Earth4dTimelineBar.timelineOffsets.indexOf(widget.selectedHourOffset);
      final nextIndex =
          (currentIndex + 1) % Earth4dTimelineBar.timelineOffsets.length;
      widget.onOffsetChanged(Earth4dTimelineBar.timelineOffsets[nextIndex]);
    });
  }

  void _stopTimer() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  String _formatOffsetTime(int hours) {
    if (hours == 0) return 'NOW (Live)';
    final targetTime = DateTime.now().add(Duration(hours: hours));
    final dateStr = DateFormat('EEE, hh:mm a').format(targetTime);
    return '+$hours H • $dateStr';
  }

  String _formatChipLabel(int hours) {
    if (hours == 0) return 'NOW';
    return '+$hours H';
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        Earth4dTimelineBar.timelineOffsets.indexOf(widget.selectedHourOffset);
    final safeIndex = currentIndex < 0 ? 0 : currentIndex;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary.withOpacity(0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar: Play/Pause, Step Prev/Next & Target Time Stamp
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(
                  widget.isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  color: AppColors.cyanAccent,
                  size: 32,
                ),
                tooltip: widget.isPlaying ? 'Pause Timeline' : 'Play Timeline',
                onPressed: () => widget.onPlayPauseToggled(!widget.isPlaying),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.skip_previous_rounded,
                    color: AppColors.textSecondary, size: 20),
                onPressed: safeIndex > 0
                    ? () => widget.onOffsetChanged(
                        Earth4dTimelineBar.timelineOffsets[safeIndex - 1])
                    : null,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.skip_next_rounded,
                    color: AppColors.textSecondary, size: 20),
                onPressed: safeIndex <
                        Earth4dTimelineBar.timelineOffsets.length - 1
                    ? () => widget.onOffsetChanged(
                        Earth4dTimelineBar.timelineOffsets[safeIndex + 1])
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.selectedHourOffset == 0
                                ? Colors.redAccent
                                : AppColors.cyanAccent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatOffsetTime(widget.selectedHourOffset),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '4D Space + Time Telemetry Forecast',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Timeline Slider Scrubber
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: AppColors.cyanAccent,
              inactiveTrackColor: AppColors.glassBorder,
              thumbColor: AppColors.cyanAccent,
              overlayColor: AppColors.cyanAccent.withOpacity(0.2),
            ),
            child: Slider(
              value: safeIndex.toDouble(),
              min: 0,
              max: (Earth4dTimelineBar.timelineOffsets.length - 1).toDouble(),
              divisions: Earth4dTimelineBar.timelineOffsets.length - 1,
              onChanged: (double val) {
                final idx = val.round();
                widget.onOffsetChanged(
                    Earth4dTimelineBar.timelineOffsets[idx]);
              },
            ),
          ),

          // Horizontal Discrete Step Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  Earth4dTimelineBar.timelineOffsets.length, (index) {
                final offset = Earth4dTimelineBar.timelineOffsets[index];
                final isSelected = offset == widget.selectedHourOffset;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => widget.onOffsetChanged(offset),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.cyanAccent
                            : AppColors.darkBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.cyanAccent
                              : AppColors.glassBorder.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        _formatChipLabel(offset),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.darkBackground
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

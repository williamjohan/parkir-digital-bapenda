import 'package:flutter/material.dart';
import '../../tokens/app_typography.dart';
import 'pb_chip_type.dart';
import 'pb_radius_type.dart';

class PbChipIndicator extends StatefulWidget {
  final String labelText;
  final PbChipType type;
  final PbRadiusType radius;
  final bool showCircleIndicator;

  const PbChipIndicator({
    super.key,
    this.type = PbChipType.idle,
    this.radius = PbRadiusType.normal,
    this.showCircleIndicator = false,
    required this.labelText,
  });

  @override
  State<PbChipIndicator> createState() => _PbChipIndicatorState();
}

class _PbChipIndicatorState extends State<PbChipIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.type.backgroundColor,
        borderRadius: widget.radius.value,
        border: Border.fromBorderSide(widget.type.border!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showCircleIndicator)
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: widget.type.foregroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Text(
            widget.labelText,
            style: AppTypography.caption.copyWith(
              color: widget.type.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

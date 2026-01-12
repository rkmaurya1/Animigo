import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/app_colors.dart';

class JoystickController extends StatefulWidget {
  final Function(Offset) onDirectionChanged;
  final double size;

  const JoystickController({
    super.key,
    required this.onDirectionChanged,
    this.size = 120,
  });

  @override
  State<JoystickController> createState() => _JoystickControllerState();
}

class _JoystickControllerState extends State<JoystickController> {
  Offset _knobPosition = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanCancel,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.overlay,
          border: Border.all(
            color: AppColors.primary.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center dot
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),

            // Knob
            Transform.translate(
              offset: _knobPosition,
              child: Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: _isDragging ? 15 : 8,
                      spreadRadius: _isDragging ? 3 : 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.games,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final localPosition = details.localPosition;
    final center = Offset(widget.size / 2, widget.size / 2);
    final delta = localPosition - center;

    // Limit knob movement to joystick radius
    final maxRadius = widget.size * 0.3;
    final distance = math.min(delta.distance, maxRadius);
    final direction = delta.direction;

    setState(() {
      _knobPosition = Offset(
        distance * math.cos(direction),
        distance * math.sin(direction),
      );
    });

    // Notify direction change (normalized)
    final normalizedDelta = _knobPosition / maxRadius;
    widget.onDirectionChanged(normalizedDelta);
  }

  void _onPanEnd(DragEndDetails details) {
    _resetKnob();
  }

  void _onPanCancel() {
    _resetKnob();
  }

  void _resetKnob() {
    setState(() {
      _knobPosition = Offset.zero;
      _isDragging = false;
    });
    widget.onDirectionChanged(Offset.zero);
  }
}

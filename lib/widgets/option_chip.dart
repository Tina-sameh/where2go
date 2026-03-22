import 'package:flutter/material.dart';

import '../constants/appColors.dart';
import '../data/option.dart';

class OptionChip extends StatefulWidget {
  final Option option;
  final int index;
  final AnimationController controller;
  final Future<void> Function(Option) onTap;

  const OptionChip({
    super.key,
    required this.option,
    required this.index,
    required this.controller,
    required this.onTap,
  });

  @override
  State<OptionChip> createState() => _OptionChipState();
}

class _OptionChipState extends State<OptionChip> {
  bool _pressed = false;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final delay = widget.index * 0.12;
    final start = delay.clamp(0.0, 0.6);
    final end = (delay + 0.5).clamp(0.1, 1.0);
    final curve = Interval(start, end, curve: Curves.easeOutCubic);

    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: widget.controller, curve: curve));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: widget.controller, curve: curve));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap(widget.option);
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
            transformAlignment: Alignment.center,
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color:
              _pressed ? const Color(0xFFEEEEEA) : AppColors.chipBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _pressed
                    ? const Color(0xFFCCCCCC)
                    : AppColors.chipBorder,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.option.emoji,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  widget.option.label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.chipText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
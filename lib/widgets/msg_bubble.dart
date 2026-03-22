import 'package:flutter/material.dart';
import '../constants/appColors.dart';
import '../data/msg.dart';
import '../data/msg_type.dart';

class MessageBubble extends StatefulWidget {
  final Msg msg;

  const MessageBubble({required this.msg, super.key});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    final isUser = widget.msg.type == MsgType.user;
    _slide = Tween<Offset>(
      begin: Offset(isUser ? 0.04 : -0.04, 0.02),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.msg.type == MsgType.user;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[const _BotAvatar(), const SizedBox(width: 8)],
              Flexible(
                child: widget.msg.isTyping
                    ? const _TypingBubble()
                    : _TextBubble(msg: widget.msg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bot Avatar ───────────────────────────────────────────────────────────────

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text('🗺️', style: TextStyle(fontSize: 13))),
    );
  }
}

// ─── Text Bubble ──────────────────────────────────────────────────────────────

class _TextBubble extends StatelessWidget {
  final Msg msg;

  const _TextBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.type == MsgType.user;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? AppColors.userBubble : AppColors.botBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft:
          isUser ? const Radius.circular(18) : const Radius.circular(4),
          bottomRight:
          isUser ? const Radius.circular(4) : const Radius.circular(18),
        ),
        border:
        isUser ? null : Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        msg.text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 15,
          height: 1.45,
          color: isUser ? AppColors.userText : AppColors.botText,
        ),
      ),
    );
  }
}

// ─── Typing Bubble ────────────────────────────────────────────────────────────

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with TickerProviderStateMixin {
  late List<AnimationController> _dotCtrls;
  late List<Animation<double>> _dotAnims;

  @override
  void initState() {
    super.initState();
    _dotCtrls = List.generate(
      3,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true),
    );
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _dotCtrls[i].repeat(reverse: true);
      });
    }
    _dotAnims = _dotCtrls.map((c) {
      return Tween<double>(
        begin: 0,
        end: -5,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _dotCtrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.botBubble,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(18),
        ),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _dotAnims[i],
            builder: (_, __) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              transform:
              Matrix4.translationValues(0, _dotAnims[i].value, 0),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFCCCCCC),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
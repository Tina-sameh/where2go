import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:where2go/widgets/buildHeaderChat.dart';
import 'package:where2go/widgets/msg_bubble.dart';

import '../constants/appColors.dart';
import '../widgets/option_chip.dart';
import 'data/msg.dart';
import 'data/msg_type.dart';
import 'data/option.dart';
import 'data/question.dart';
import 'data/questions_data.dart';

class WhereToGoScreen extends StatefulWidget {
  static const String routeName = 'where_to_go';

  const WhereToGoScreen({super.key});

  @override
  State<WhereToGoScreen> createState() => _WhereToGoScreenState();
}

class _WhereToGoScreenState extends State<WhereToGoScreen>
    with TickerProviderStateMixin {
  final _scrollCtrl = ScrollController();
  final TextEditingController _locationController = TextEditingController();

  final List<Msg> _messages = [];
  final List<String> _history = [];

  String _currentId = 'q1';

  bool _isDone = false;
  bool _isTyping = false;
  bool _isTextInput = false;

  List<Option> _currentOptions = [];

  late AnimationController _chipCtrl;

  @override
  void initState() {
    super.initState();
    _chipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _showQuestion('q1'));
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _chipCtrl.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ─── Scroll ─────────────────────────

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Show Question ─────────────────

  Future<void> _showQuestion(String id) async {
    final q = questionsData[id]!;

    setState(() {
      _isTyping = true;
      _currentOptions = [];
      _isTextInput = false;
      _messages.add(Msg(text: '', type: MsgType.bot, isTyping: true));
    });

    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      _messages.removeLast();
      _isTyping = false;
      _messages.add(Msg(text: q.text, type: MsgType.bot));

      if (q.type == QuestionType.textInput) {
        _isTextInput = true;
        _currentOptions = [];
      } else {
        _isTextInput = false;
        _currentOptions = q.options ?? [];
      }
    });

    _chipCtrl.forward(from: 0);
    _scrollToBottom();
  }

  // ─── Option Tap ───────────────────

  Future<void> _onOptionTap(Option opt) async {
    HapticFeedback.mediumImpact();
    _chipCtrl.reverse();

    setState(() {
      _currentOptions = [];
      _messages.add(Msg(text: '${opt.emoji} ${opt.label}', type: MsgType.user));
    });

    _scrollToBottom();

    if (opt.next != null) {
      _history.add(_currentId);
      _currentId = opt.next!;
      await Future.delayed(const Duration(milliseconds: 300));
      _showQuestion(_currentId);
    }
  }

  // ─── Submit Location ──────────────

  void _submitLocation() {
    final text = _locationController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Msg(text: text, type: MsgType.user));
      _locationController.clear();
      _isTextInput = false;
    });

    _scrollToBottom();

    _currentId = 'q_done';
    _showQuestion(_currentId);
  }

  // ─── Reset ───────────────────────

  Future<void> _reset() async {
    setState(() {
      _messages.clear();
      _history.clear();
      _currentId = 'q1';
      _isDone = false;
      _currentOptions = [];
      _isTextInput = false;
    });

    await Future.delayed(const Duration(milliseconds: 100));
    _showQuestion('q1');
  }

  // ─── Build ───────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Column(
          children: [
            buildHeaderChat(),
            Expanded(child: _buildMessages()),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  // ─── Messages ────────────────────

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (_, i) {
        final msg = _messages[i];
        return MessageBubble(msg: msg, key: ValueKey(i));
      },
    );
  }

  // ─── Bottom ──────────────────────

  Widget _buildBottom() {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            if (_isDone)
              _buildDoneActions()
            else if (_isTextInput)
              _buildTextInput() // 🔥 هنا المهم
            else if (_currentOptions.isNotEmpty)
                _buildChips()
              else
                _buildTypingIndicatorRow(),
          ],
        ),
      ),
    );
  }

  // ─── Text Input ───────────────────

  Widget _buildTextInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'اكتب المكان...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _submitLocation,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ─── Chips ───────────────────────

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: _currentOptions.map((opt) {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: OptionChip(
              option: opt,
              index: 0,
              controller: _chipCtrl,
              onTap: _onOptionTap,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Typing ──────────────────────

  Widget _buildTypingIndicatorRow() {
    return const SizedBox(
      height: 36,
      child: Center(
        child: Text('بيفكر...'),
      ),
    );
  }

  // ─── Done ────────────────────────

  Widget _buildDoneActions() {
    return GestureDetector(
      onTap: _reset,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: Colors.black,
        child: const Center(
          child: Text(
            'ابدأ من الأول',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
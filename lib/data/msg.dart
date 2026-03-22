import 'msg_type.dart';

class Msg {
  final String text;
  final MsgType type;
  final bool isTyping;

  const Msg({required this.text, required this.type, this.isTyping = false});
}

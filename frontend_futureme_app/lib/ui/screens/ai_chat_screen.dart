// Layar AI Chatbot personal, dengan animasi pesan fade-in.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../providers/ai_chat_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class AiChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final chat = chatProvider.chatHistory;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.aiChatbot)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chat.length,
              itemBuilder: (ctx, i) {
                final msg = chat[i];
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: animationDuration,
                  child: ListTile(
                    title: Text(msg['user'] ?? msg['ai'] ?? ''),
                    trailing: msg['user'] != null ? Icon(Icons.person) : Icon(Icons.android),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: 'Ketik pesan...',
                    controller: _controller,
                  ),
                ),
                CustomButton(
                  text: 'Kirim',
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<ChatProvider>().sendMessage(context, _controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
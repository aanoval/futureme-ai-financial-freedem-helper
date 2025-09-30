// Dokumen: Layar AI Chatbot personal dengan desain modern, bubble chat, dan animasi halus.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../providers/ai_chat_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _controllerAnimation;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeInOut),
    );
    _controllerAnimation.forward();
  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final chat = chatProvider.chatHistory;

    // Scroll ke bawah setiap kali chat diperbarui
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeChat, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.background,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: chat.length,
                    itemBuilder: (ctx, i) {
                      final msg = chat[i];
                      final isUser = msg['user'] != null;
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controllerAnimation,
                            curve: Interval(0.2 * i, 1.0, curve: Curves.easeIn),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.primary.withOpacity(0.1) : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              if (!isUser) const Icon(Icons.android, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  msg['user'] ?? msg['ai'] ?? '',
                                  style: AppTextStyles.body,
                                ),
                              ),
                              if (isUser) const SizedBox(width: 8),
                              if (isUser) const Icon(Icons.person, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hint: AppStrings.homeChat,
                        controller: _controller,
                        prefixIcon: Icons.chat_bubble_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: AppStrings.save,
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          chatProvider.sendMessage(context, _controller.text);
                          _controller.clear();
                          _scrollToBottom();
                        }
                      },
                      backgroundColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
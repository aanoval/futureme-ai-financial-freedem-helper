import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/ai_chat_provider.dart';
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
    // Load chat history from local storage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadChatHistory();
    });
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

    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeChat, style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.background,
                child: chat.isEmpty
                    ? Center(
                        child: Text(
                          'Mulai percakapan dengan AI!',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: chat.length,
                        itemBuilder: (ctx, i) {
                          final msg = chat[i];
                          final isUser = msg['user'] != null;
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _controllerAnimation,
                                curve: Interval(0.1 * i, 1.0, curve: Curves.easeIn),
                              ),
                            ),
                            child: Align(
                              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser ? AppColors.primary.withOpacity(0.9) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isUser) ...[
                                      const Icon(Icons.smart_toy, color: AppColors.textSecondary, size: 20),
                                      const SizedBox(width: 8),
                                    ],
                                    Flexible(
                                      child: Text(
                                        msg['user'] ?? msg['ai'] ?? AppStrings.errorApi,
                                        style: AppTextStyles.body.copyWith(
                                          color: isUser ? Colors.white : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (isUser) ...[
                                      const SizedBox(width: 8),
                                      const Icon(Icons.person, color: Colors.white, size: 20),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              color: AppColors.cardBackground,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hint: 'Ketik pesan...',
                      controller: _controller,
                      prefixIcon: Icons.message,
                      validator: (val) => val!.isEmpty ? 'Pesan tidak boleh kosong' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary, size: 28),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context.read<ChatProvider>().sendMessage(context, _controller.text);
                        _controller.clear();
                        _scrollToBottom();
                      }
                    },
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
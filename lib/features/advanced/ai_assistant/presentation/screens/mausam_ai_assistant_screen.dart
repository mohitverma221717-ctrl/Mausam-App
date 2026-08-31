import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/ai_assistant/domain/models/ai_message_model.dart';
import 'package:mausam_app/features/advanced/ai_assistant/domain/services/mausam_ai_engine.dart';

class MausamAiAssistantScreen extends ConsumerStatefulWidget {
  const MausamAiAssistantScreen({super.key});

  @override
  ConsumerState<MausamAiAssistantScreen> createState() =>
      _MausamAiAssistantScreenState();
}

class _MausamAiAssistantScreenState
    extends ConsumerState<MausamAiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<MausamAiMessage> _messages = [];
  bool _isThinking = false;

  final List<String> _suggestedPrompts = [
    'Is today good for running?',
    'What should I carry for tomorrow?',
    'Will it rain this evening?',
    'What are today\'s weather risks?',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      MausamAiMessage(
        id: 'welcome',
        text:
            'Hello! I am your Mausam Weather AI Assistant. How can I help you plan your day around live weather conditions?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = MausamAiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isThinking = true;
    });

    _controller.clear();

    final engine = ref.read(mausamAiEngineProvider);
    final aiReply = await engine.generateResponse(userMsg.text);

    if (mounted) {
      setState(() {
        _messages.add(aiReply);
        _isThinking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackgroundSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: const [
            Icon(Icons.smart_toy_rounded,
                color: AppColors.cyanAccent, size: 22),
            SizedBox(width: 10),
            Text(
              'Mausam AI Assistant',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Context Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.darkBackgroundSecondary.withOpacity(0.5),
            child: Row(
              children: const [
                Icon(Icons.verified_rounded,
                    size: 14, color: AppColors.cyanAccent),
                SizedBox(width: 8),
                Text(
                  'Grounded in Live Telemetry & Verified Weather Context',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final timeStr = DateFormat('h:mm a').format(msg.timestamp);

                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppColors.cyanAccent
                          : AppColors.darkBackgroundSecondary,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: msg.isUser
                            ? Radius.zero
                            : const Radius.circular(16),
                        bottomLeft: !msg.isUser
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                      border: Border.all(
                        color: msg.isUser
                            ? AppColors.cyanAccent
                            : AppColors.glassBorder.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isUser
                                ? AppColors.darkBackground
                                : AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            timeStr,
                            style: TextStyle(
                              color: msg.isUser
                                  ? AppColors.darkBackground.withOpacity(0.6)
                                  : AppColors.textMuted,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isThinking)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.cyanAccent),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Mausam AI is evaluating weather telemetry...',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),

          // Suggested Prompts
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: _suggestedPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(
                      prompt,
                      style: const TextStyle(
                        color: AppColors.cyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: AppColors.darkBackgroundSecondary,
                    side: BorderSide(
                        color: AppColors.cyanAccent.withOpacity(0.3)),
                    onPressed: () => _sendMessage(prompt),
                  ),
                );
              }).toList(),
            ),
          ),

          // Input Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkBackgroundSecondary,
              border: Border(
                  top: BorderSide(
                      color: AppColors.glassBorder.withOpacity(0.5))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Ask weather advice or recommendations...',
                      hintStyle:
                          TextStyle(color: AppColors.textMuted, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded,
                      color: AppColors.cyanAccent),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

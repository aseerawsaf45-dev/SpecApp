import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String channelName;
  
  const ChatScreen({super.key, required this.channelName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatMessageItem {
  final String sender;
  final String role;
  final String time;
  final String message;
  final bool isDecision;
  final String? decisionId;

  _ChatMessageItem({
    required this.sender,
    required this.role,
    required this.time,
    required this.message,
    this.isDecision = false,
    this.decisionId,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<_ChatMessageItem> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      _ChatMessageItem(
        sender: 'Aseer Awsaf',
        role: 'Event Lead',
        time: '09:12 AM',
        message: 'The registration location has been changed to the Auditorium Entrance due to expected crowd movement from the main gate.',
      ),
      _ChatMessageItem(
        sender: 'Decision Bot',
        role: 'Operations Engine',
        time: '09:12 AM',
        message: 'Registration Desk Location updated to Auditorium Entrance.',
        isDecision: true,
        decisionId: '024',
      ),
      _ChatMessageItem(
        sender: 'Foysal',
        role: 'Coordinator',
        time: '09:15 AM',
        message: 'Noted. I will update the volunteer allocation sheet and floor signage immediately.',
      ),
      _ChatMessageItem(
        sender: 'Tahsina',
        role: 'Logistics',
        time: '09:22 AM',
        message: 'Power cables and network check at Auditorium lobby confirmed operational.',
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessageItem(
          sender: 'Aseer Awsaf',
          role: 'Event Lead',
          time: 'Now',
          message: text,
        ),
      );
    });
    _controller.clear();

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
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.hash, size: 16, color: AppColors.primaryYellow),
                const SizedBox(width: 4),
                Text(
                  widget.channelName,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Text(
              'Event Operations · 47 Members',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedWhite,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search, color: AppColors.mutedWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.users, color: AppColors.mutedWhite),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.darkBorder, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Text(
                          'Beginning of #${widget.channelName}',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mutedWhite,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final item = _messages[index - 1];
                if (item.isDecision) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildDecisionCard(context, item),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildMessageBubble(context, item),
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, _ChatMessageItem item) {
    final isMe = item.sender == 'Aseer Awsaf';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: isMe ? AppColors.primaryYellow : AppColors.charcoal,
          child: Text(
            item.sender[0],
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isMe ? AppColors.deepBlack : AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.sender,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Text(
                      item.role,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.time,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E6E6E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Text(
                  item.message,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionCard(BuildContext context, _ChatMessageItem item) {
    return Container(
      margin: const EdgeInsets.only(left: 46),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryYellow.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.fileSignature, color: AppColors.primaryYellow, size: 16),
              const SizedBox(width: 8),
              Text(
                'OPERATIONAL DECISION #${item.decisionId ?? "024"}',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryYellow,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.message,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () => context.push('/decision/${item.decisionId ?? "024"}'),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VIEW DECISION LOG',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryYellow,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.primaryYellow),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlack,
        border: Border(top: BorderSide(color: AppColors.darkBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.plusCircle, color: AppColors.mutedWhite),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Message #${widget.channelName}...',
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.mutedWhite.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.send,
                  color: AppColors.deepBlack,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

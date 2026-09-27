import '../../../shared/widgets/gradient_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';

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
        sender: 'Salman Farshi Alam',
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
          sender: 'Salman Farshi Alam',
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
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: PressableScale(
          onTap: () => context.pop(),
          child: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
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
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Text(
              'Event Operations · 47 Members Online',
              style: GoogleFonts.plusJakartaSans(
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
      body: GradientMeshBackground(
        child: SafeArea(
          child: Column(
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.charcoal,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Text(
                          'Beginning of #${widget.channelName}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedWhite,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final item = _messages[index - 1];
                if (item.isDecision) {
                  return StaggeredEntrance(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildDecisionCard(context, item),
                    ),
                  );
                }

                return StaggeredEntrance(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildMessageBubble(context, item),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
        ),
      ),
    ),
  );
}

  Widget _buildMessageBubble(BuildContext context, _ChatMessageItem item) {
    final isMe = item.sender == 'Salman Farshi Alam';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: isMe ? AppColors.primaryYellow : AppColors.charcoal,
          child: Text(
            item.sender[0],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
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
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.elevatedSurface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Text(
                      item.role,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isMe ? AppColors.primaryYellow : AppColors.mutedWhite,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.time,
                    style: GoogleFonts.plusJakartaSans(
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
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.45,
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
    return Padding(
      padding: const EdgeInsets.only(left: 46),
      child: AnimatedGlowingBorder(
        borderRadius: 16,
        glowColor: AppColors.primaryYellow,
        borderWidth: 1.4,
        surfaceColor: const Color(0xFF141414),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PulsingBeacon(dotSize: 4.5, maxAuraSize: 11),
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.fileSignature, color: AppColors.primaryYellow, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'OPERATIONAL DECISION #${item.decisionId ?? "024"}',
                    style: GoogleFonts.plusJakartaSans(
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
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              PressableScale(
                onTap: () => context.push('/decision/${item.decisionId ?? "024"}'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'VIEW DECISION LOG',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
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
            ],
          ),
        ),
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
            PressableScale(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: const Icon(LucideIcons.plusCircle, color: AppColors.mutedWhite, size: 20),
              ),
            ),
            const SizedBox(width: 10),
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
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Message #${widget.channelName}...',
                    hintStyle: GoogleFonts.plusJakartaSans(
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
            const SizedBox(width: 10),
            PressableScale(
              onTap: _sendMessage,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryYellow.withValues(alpha: 0.35),
                      blurRadius: 10,
                    ),
                  ],
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

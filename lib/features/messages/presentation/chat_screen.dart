import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/models/event_ops_models.dart';
import '../../../core/state/operations_state.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/gradient_mesh_background.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String channelName;

  const ChatScreen({super.key, required this.channelName});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isUrgentMode = false;

  final List<String> _quickPrompts = [
    'All clear at Gate 2',
    'Relief volunteer needed',
    'Power & AV check OK',
    'VIP Escort protocol active',
    'Decision verified & executed',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _controller.text.trim();
    if (text.isEmpty) return;

    ref.read(operationsProvider).sendChatMessage(
      widget.channelName,
      text,
      isUrgent: _isUrgentMode,
    );

    _controller.clear();
    setState(() => _isUrgentMode = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ops = ref.watch(operationsProvider);
    final messages = ops.getMessagesForChannel(widget.channelName);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: PressableScale(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
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
              'Event Operations · 43 Officers On Duty',
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
            icon: const Icon(LucideIcons.users, color: AppColors.mutedWhite),
            onPressed: () => context.push('/team_roster'),
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
                  itemCount: messages.length + 1,
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
                              'Beginning of #${widget.channelName} transmission feed',
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

                    final item = messages[index - 1];
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
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _buildMessageBubble(context, item, ops),
                      ),
                    );
                  },
                ),
              ),

              // Quick Tactical Prompts Bar
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickPrompts.length,
                  itemBuilder: (context, i) {
                    final p = _quickPrompts[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _sendMessage(p),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.charcoal,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Text(
                            p,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedWhite,
                            ),
                          ),
                        ),
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

  Widget _buildMessageBubble(BuildContext context, ChatMessageModel item, OperationsNotifier ops) {
    final isMe = item.sender == ops.currentUserName;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: isMe ? AppColors.primaryYellow : AppColors.charcoal,
          child: Text(
            item.sender.isNotEmpty ? item.sender[0] : 'U',
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
                  if (item.isUrgent) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.statusRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'URGENT',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.statusRed,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: item.isUrgent
                      ? const Color(0xFF240A0A)
                      : AppColors.charcoal,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.isUrgent
                        ? AppColors.statusRed.withValues(alpha: 0.4)
                        : AppColors.darkBorder,
                  ),
                ),
                child: Text(
                  item.message,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),

              // Reactions Bar
              const SizedBox(height: 6),
              Row(
                children: [
                  ...item.reactions.entries.map((entry) {
                    final emoji = entry.key;
                    final count = entry.value;
                    final isUserReacted = item.userReactions.contains(emoji);
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => ops.toggleReaction(widget.channelName, item.id, emoji),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: isUserReacted
                                ? AppColors.primaryYellow.withValues(alpha: 0.2)
                                : AppColors.elevatedSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isUserReacted ? AppColors.primaryYellow : AppColors.darkBorder,
                            ),
                          ),
                          child: Text(
                            '$emoji $count',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isUserReacted ? AppColors.primaryYellow : AppColors.mutedWhite,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // Quick add reactions button
                  InkWell(
                    onTap: () => ops.toggleReaction(widget.channelName, item.id, '👍'),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('👍', style: TextStyle(fontSize: 10)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => ops.toggleReaction(widget.channelName, item.id, '🔥'),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('🔥', style: TextStyle(fontSize: 10)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => ops.toggleReaction(widget.channelName, item.id, '✅'),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('✅', style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionCard(BuildContext context, ChatMessageModel item) {
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
                    'OPERATIONAL DIRECTIVE #${item.decisionId ?? "024"}',
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
                        'OPEN DIRECTIVE BALLOT',
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlack,
        border: Border(top: BorderSide(color: AppColors.darkBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Urgent Toggle Button
            InkWell(
              onTap: () => setState(() => _isUrgentMode = !_isUrgentMode),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isUrgentMode
                      ? AppColors.statusRed.withValues(alpha: 0.2)
                      : AppColors.charcoal,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isUrgentMode ? AppColors.statusRed : AppColors.darkBorder,
                  ),
                ),
                child: Icon(
                  LucideIcons.alertTriangle,
                  color: _isUrgentMode ? AppColors.statusRed : AppColors.mutedWhite,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isUrgentMode
                        ? AppColors.statusRed.withValues(alpha: 0.5)
                        : AppColors.darkBorder,
                  ),
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
                    hintText: _isUrgentMode
                        ? 'Broadcasting urgent alert in #${widget.channelName}...'
                        : 'Message #${widget.channelName}...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: _isUrgentMode
                          ? AppColors.statusRed.withValues(alpha: 0.7)
                          : AppColors.mutedWhite.withValues(alpha: 0.6),
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
              onTap: () => _sendMessage(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: _isUrgentMode
                      ? const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFEF4444)])
                      : AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isUrgentMode ? AppColors.statusRed : AppColors.primaryYellow)
                          .withValues(alpha: 0.35),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  LucideIcons.send,
                  color: _isUrgentMode ? Colors.white : AppColors.deepBlack,
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

// reaction_details_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class ReactionDetailsSheet extends StatefulWidget {
  const ReactionDetailsSheet({super.key, required this.postId});

  final String postId;

  @override
  State<ReactionDetailsSheet> createState() => _ReactionDetailsSheetState();
}

class _ReactionDetailsSheetState extends State<ReactionDetailsSheet>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Tab> _tabs = [];
  ReactionSummary? reactionData;



  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    ReactCubit.get(context).getAllReactions(widget.postId);
  }



  List<Tab> _buildTabs() {
    final tabs = <Tab>[];
    if (reactionData == null) return tabs;

    // All Tab with mixed reaction icons
    tabs.add(
      Tab(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _getStackWidth(),
                height: 24,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildAllTabIcons(),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${reactionData!.totalReactCount}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Individual reaction tabs
    if (reactionData!.likeCount > 0) {
      tabs.add(_buildReactionTab(ReactType.like, reactionData!.likeCount));
    }
    if (reactionData!.loveCount > 0) {
      tabs.add(_buildReactionTab(ReactType.love, reactionData!.loveCount));
    }
    if (reactionData!.happyCount > 0) {
      tabs.add(_buildReactionTab(ReactType.happy, reactionData!.happyCount));
    }
    if (reactionData!.sadCount > 0) {
      tabs.add(_buildReactionTab(ReactType.sad, reactionData!.sadCount));
    }
    if (reactionData!.angryCount > 0) {
      tabs.add(_buildReactionTab(ReactType.angry, reactionData!.angryCount));
    }

    return tabs;
  }

  List<Widget> _buildAllTabIcons() {
    final icons = <Widget>[];
    double offset = 0;

    if (reactionData!.likeCount > 0) {
      icons.add(_buildTabIcon(ReactType.like, offset));
      offset += 12;
    }
    if (reactionData!.loveCount > 0) {
      icons.add(_buildTabIcon(ReactType.love, offset));
      offset += 12;
    }
    if (reactionData!.happyCount > 0) {
      icons.add(_buildTabIcon(ReactType.happy, offset));
      offset += 12;
    }
    if (reactionData!.sadCount > 0) {
      icons.add(_buildTabIcon(ReactType.sad, offset));
      offset += 12;
    }
    if (reactionData!.angryCount > 0) {
      icons.add(_buildTabIcon(ReactType.angry, offset));
    }

    return icons;
  }

  Widget _buildTabIcon(ReactType type, double leftOffset) {
    return Positioned(
      left: leftOffset,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Image.asset(
            getReactionIcon(type),
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  double _getStackWidth() {
    if (reactionData == null) return 24;
    int activeReactions = 0;
    if (reactionData!.likeCount > 0) activeReactions++;
    if (reactionData!.loveCount > 0) activeReactions++;
    if (reactionData!.happyCount > 0) activeReactions++;
    if (reactionData!.sadCount > 0) activeReactions++;
    if (reactionData!.angryCount > 0) activeReactions++;

    return activeReactions > 1 ? (12.0 * (activeReactions - 1)) + 24 : 24;
  }

  Tab _buildReactionTab(ReactType type, int count) {
    return Tab(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              getReactionIcon(type),
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ReactionItem> _getAllReactions() {
    if (reactionData == null) return [];
    return [
      ...reactionData!.likeReaction,
      ...reactionData!.loveReaction,
      ...reactionData!.happyReaction,
      ...reactionData!.sadReaction,
      ...reactionData!.angryReaction,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReactCubit, ReactState>(
      listener: (context, state) {
        if (state is GetReactionsSuccess) {
          setState(() {
            reactionData = state.reactions;
            _tabs = _buildTabs();
            _tabController?.dispose();
            _tabController = TabController(length: _tabs.length, vsync: this);
          });
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: reactionData == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reactions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 3,
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: _tabs,
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReactionList(_getAllReactions()),
                  if (reactionData!.likeCount > 0)
                    _buildReactionList(reactionData!.likeReaction),
                  if (reactionData!.loveCount > 0)
                    _buildReactionList(reactionData!.loveReaction),
                  if (reactionData!.happyCount > 0)
                    _buildReactionList(reactionData!.happyReaction),
                  if (reactionData!.sadCount > 0)
                    _buildReactionList(reactionData!.sadReaction),
                  if (reactionData!.angryCount > 0)
                    _buildReactionList(reactionData!.angryReaction),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionList(List<ReactionItem> reactions) {
    if (reactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_neutral,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No reactions yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: reactions.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 72,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final reaction = reactions[index];
        final displayName =
            reaction.owner?.fullName ?? reaction.pet?.petName ?? 'Unknown';
        final imageName =
            reaction.owner?.imageName ?? reaction.pet?.imageName ?? '';
        final reactType = ReactType.values.firstWhere(
              (r) => r.index == reaction.reactType,
          orElse: () => ReactType.like,
        );

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: imageName.isNotEmpty
                      ? NetworkImage(imageUrl +imageName)
                      : null,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: imageName.isEmpty
                      ? Text(
                    displayName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                      : null,
                ),
              ),
              // Reaction Icon Badge
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    getReactionIcon(reactType),
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            displayName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: reaction.pet != null
              ? Row(
            children: [
              Icon(
                Icons.pets,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Pet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          )
              : null,
          trailing: reaction.owner != null
              ? Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          )
              : null,
          onTap: () {
            // Navigate to profile
            // You can add navigation logic here
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _tabController = null;
    reactionData = null;
    _tabs = [];
    super.dispose();
  }
}

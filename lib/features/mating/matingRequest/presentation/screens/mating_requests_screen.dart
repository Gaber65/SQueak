import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/mating_request.dart';

class MatingRequestsScreen extends StatelessWidget {
  const MatingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.pink.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Mating Requests for currentProfile',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage incoming and outgoing mating requests',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Received (${MatingRequest.dummyMatingRequests.where((r) => r.status == RequestStatus.pending).length})',
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send, size: 16),
                    const SizedBox(width: 4),
                    Text('Sent (1)'),
                  ],
                ),
              ),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              children: [_ReceivedRequestsTab(), _SentRequestsTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceivedRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: MatingRequest.dummyMatingRequests.length,
      itemBuilder: (context, index) {
        final request = MatingRequest.dummyMatingRequests[index];
        return _RequestCard(
          request: request,
          isReceived: true,
          onAccept: () {},
          onReject: () {},
        );
      },
    );
  }
}

class _SentRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        final sentRequests = petProvider.sentRequests;

        if (sentRequests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Sent Requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Requests you send will appear here',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sentRequests.length,
          itemBuilder: (context, index) {
            final request = sentRequests[index];
            return _RequestCard(request: request, isReceived: false);
          },
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  final MatingRequest request;
  final bool isReceived;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _RequestCard({
    required this.request,
    required this.isReceived,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final pet = isReceived ? request.fromPet : request.toPet;
    final timeAgo = _getTimeAgo(request.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Pet Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    pet.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Pet Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pet.breed} • ${pet.age}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status and Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: request.status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(request.status),
                            size: 12,
                            color: request.status.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.status.displayName,
                            style: TextStyle(
                              color: request.status.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request.message,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),

            // Action Buttons
            if (isReceived && request.status == RequestStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (isReceived && request.status == RequestStatus.accepted) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to chat
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening chat...')),
                    );
                  },
                  child: const Text('Open Chat'),
                ),
              ),
            ],

            if (!isReceived && request.status == RequestStatus.pending) ...[
              const SizedBox(height: 12),
              const Text(
                'Waiting for response...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.schedule;
      case RequestStatus.accepted:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

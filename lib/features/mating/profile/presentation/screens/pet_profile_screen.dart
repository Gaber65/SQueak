import 'package:flutter/material.dart';
import 'package:squeak/features/mating/feeds/domain/entities/pet_mating_model.dart';
import '../widgets/status_manager_dialog.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = PetMating(
      id: 'available-2',
      name: 'Max',
      breed: 'German Shepherd',
      gender: 'Male',
      age: '3 years',
      description: 'Very gentle and well-trained',
      profilePicture: 'assets/images/max.jpg',
      status: PetMatingStatus.onMating,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Profile'),
      ),
      body: SingleChildScrollView(
        physics:BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Picture and Basic Info
                    Row(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            pet.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Pet Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      pet.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _showStatusManager(context),
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit Status',
                                  ),
                                ],
                              ),
                              Text(
                                pet.breed,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: pet.status.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      pet.status.displayName,
                                      style: TextStyle(
                                        color: pet.status.color,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      pet.gender,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.calendar_today,
                          label: 'Age',
                          value: pet.age.isEmpty ? 'Unknown' : pet.age,
                        ),
                        const _StatItem(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: 'Cairo, Egypt',
                        ),
                        const _StatItem(
                          icon: Icons.star,
                          label: 'Rating',
                          value: '4.8',
                        ),
                        const _StatItem(
                          icon: Icons.favorite,
                          label: 'Matches',
                          value: '12',
                        ),
                      ],
                    ),

                    if (pet.description != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pet.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Profile Tabs
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.pink,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.pink,
                    tabs: [
                      Tab(text: 'Posts'),
                      Tab(text: 'Photos'),
                      Tab(text: 'History'),
                      Tab(text: 'Ratings'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        _PostsTab(pet: pet),
                        _PhotosTab(),
                        _HistoryTab(),
                        _RatingsTab(pet: pet),
                      ],
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

  void _showStatusManager(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const StatusManagerDialog(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

class _PostsTab extends StatelessWidget {
  final PetMating pet;

  const _PostsTab({required this.pet});

  @override
  Widget build(BuildContext context) {
    final autoGeneratedPosts = [
      {
        'title': '${pet.name} is looking for love!',
        'content':
            'Ready to find the one! 💕 ${pet.name} is now open for love!',
        'timestamp': '2 hours ago',
        'reactions': 12,
        'comments': 3,
      },
      {
        'title': '${pet.name} completed profile!',
        'content':
            'All set and ready to mingle! 🎉 ${pet.name} just completed their profile.',
        'timestamp': '1 day ago',
        'reactions': 8,
        'comments': 1,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: autoGeneratedPosts.length,
      itemBuilder: (context, index) {
        final post = autoGeneratedPosts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      post['timestamp'] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post['content'] as String,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border, size: 16),
                      label: Text('${post['reactions']} reactions'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.pink,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined, size: 16),
                      label: Text('${post['comments']} comments'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined, size: 16),
                      label: const Text('Share'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhotosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Photo ${index + 1}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = [
      {
        'partner': 'Bella',
        'date': 'March 2024',
        'status': 'Completed',
        'rating': 5,
      },
      {
        'partner': 'Luna',
        'date': 'January 2024',
        'status': 'Completed',
        'rating': 4,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('Mated with ${item['partner']}'),
            subtitle: Text(item['date'] as String),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      '${item['rating']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RatingsTab extends StatelessWidget {
  final PetMating pet;

  const _RatingsTab({required this.pet});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text('B', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Bella\'s Owner',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                size: 16,
                                color: index < 5 ? Colors.amber : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Amazing experience! ${pet.name} was very gentle and well-behaved. Highly recommended!',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

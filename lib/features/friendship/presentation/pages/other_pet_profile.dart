// import 'package:flutter/material.dart';

// enum FriendshipStatus {
//   notFriends,
//   requestSent,
//   requestReceived,
//   friends,
//   blocked,
// }

// class User {
//   final String id;
//   final String name;
//   final String type;
//   final String breed;
//   final String bio;
//   final String profileImage;
//   final String coverImage;
//   int friendsCount;
//   final int postsCount;
//   FriendshipStatus friendshipStatus;
//   final List<Post> posts;
//   final List<MutualFriend> mutualFriends;

//   User({
//     required this.id,
//     required this.name,
//     required this.type,
//     required this.breed,
//     required this.bio,
//     required this.profileImage,
//     required this.coverImage,
//     required this.friendsCount,
//     required this.postsCount,
//     required this.friendshipStatus,
//     required this.posts,
//     required this.mutualFriends,
//   });
// }

// class Post {
//   final String id;
//   final String content;
//   final String? image;
//   final int likes;
//   final int comments;
//   final DateTime timestamp;

//   Post({
//     required this.id,
//     required this.content,
//     this.image,
//     required this.likes,
//     required this.comments,
//     required this.timestamp,
//   });
// }

// class MutualFriend {
//   final String id;
//   final String name;
//   final String profileImage;

//   MutualFriend({
//     required this.id,
//     required this.name,
//     required this.profileImage,
//   });
// }

// // Dummy Data
// class DummyData {
//   static User getUser(String userId, FriendshipStatus status) {
//     final users = {
//       'user1': User(
//         id: 'user1',
//         name: 'Max the Golden',
//         type: 'pet',
//         breed: 'Golden Retriever',
//         bio: '🐕 Living my best doggo life! Love treats, belly rubs, and chasing tennis balls 🎾',
//         profileImage: 'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=400',
//         coverImage: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=800',
//         friendsCount: 234,
//         postsCount: 89,
//         friendshipStatus: status,
//         posts: [
//           Post(
//             id: 'p1',
//             content: 'Had the best day at the dog park today! Made so many new furry friends 🐾',
//             image: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=600',
//             likes: 156,
//             comments: 23,
//             timestamp: DateTime.now().subtract(const Duration(hours: 2)),
//           ),
//           Post(
//             id: 'p2',
//             content: 'Who else loves rainy days and cozy naps? 💤☔',
//             likes: 89,
//             comments: 12,
//             timestamp: DateTime.now().subtract(const Duration(days: 1)),
//           ),
//           Post(
//             id: 'p3',
//             content: 'Beach day vibes! 🏖️🌊',
//             image: 'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=600',
//             likes: 203,
//             comments: 34,
//             timestamp: DateTime.now().subtract(const Duration(days: 3)),
//           ),
//         ],
//         mutualFriends: [
//           MutualFriend(
//             id: 'm1',
//             name: 'Bella',
//             profileImage: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=100',
//           ),
//           MutualFriend(
//             id: 'm2',
//             name: 'Charlie',
//             profileImage: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=100',
//           ),
//           MutualFriend(
//             id: 'm3',
//             name: 'Luna',
//             profileImage: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=100',
//           ),
//         ],
//       ),
//       'user2': User(
//         id: 'user2',
//         name: 'Whiskers McFluff',
//         type: 'pet',
//         breed: 'Persian Cat',
//         bio: '😼 Professional napper. Part-time troublemaker. Full-time adorable.',
//         profileImage: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400',
//         coverImage: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800',
//         friendsCount: 189,
//         postsCount: 124,
//         friendshipStatus: status,
//         posts: [
//           Post(
//             id: 'p4',
//             content: 'Knocked everything off the counter. No regrets. 😸',
//             image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?w=600',
//             likes: 245,
//             comments: 45,
//             timestamp: DateTime.now().subtract(const Duration(hours: 5)),
//           ),
//         ],
//         mutualFriends: [
//           MutualFriend(
//             id: 'm4',
//             name: 'Mittens',
//             profileImage: 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=100',
//           ),
//         ],
//       ),
//     };
//     return users[userId]!;
//   }

//   static List<User> getBlockedPets() {
//     return [
//       User(
//         id: 'blocked1',
//         name: 'Rufus the Rascal',
//         type: 'pet',
//         breed: 'Jack Russell Terrier',
//         bio: 'Too energetic for my own good!',
//         profileImage: 'https://images.unsplash.com/photo-1477884213360-7e9d7dcc1e48?w=400',
//         coverImage: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=800',
//         friendsCount: 156,
//         postsCount: 45,
//         friendshipStatus: FriendshipStatus.blocked,
//         posts: [],
//         mutualFriends: [],
//       ),
//       User(
//         id: 'blocked2',
//         name: 'Grumpy Cat Jr.',
//         type: 'pet',
//         breed: 'British Shorthair',
//         bio: 'Always grumpy, never happy.',
//         profileImage: 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=400',
//         coverImage: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800',
//         friendsCount: 89,
//         postsCount: 23,
//         friendshipStatus: FriendshipStatus.blocked,
//         posts: [],
//         mutualFriends: [],
//       ),
//     ];
//   }
// }

// class ProfileScreen extends StatefulWidget {
//   final String userId;

//   const ProfileScreen({super.key, required this.userId});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late User user;
//   String selectedTab = 'Posts';

//   @override
//   void initState() {
//     super.initState();
//     user = DummyData.getUser(widget.userId, FriendshipStatus.notFriends);
//   }

//   void _handleFriendAction(FriendshipStatus currentStatus) {
//     setState(() {
//       switch (currentStatus) {
//         case FriendshipStatus.notFriends:
//           user.friendshipStatus = FriendshipStatus.requestSent;
//           _showSnackBar('Friend request sent to ${user.name}');
//           break;
//         case FriendshipStatus.requestSent:
//           user.friendshipStatus = FriendshipStatus.notFriends;
//           _showSnackBar('Friend request cancelled');
//           break;
//         case FriendshipStatus.requestReceived:
//           user.friendshipStatus = FriendshipStatus.friends;
//           user.friendsCount++;
//           _showSnackBar('You are now friends with ${user.name}');
//           break;
//         case FriendshipStatus.friends:
//           user.friendshipStatus = FriendshipStatus.notFriends;
//           user.friendsCount--;
//           _showSnackBar('Removed ${user.name} from friends');
//           break;
//         case FriendshipStatus.blocked:
//           user.friendshipStatus = FriendshipStatus.notFriends;
//           _showSnackBar('Unblocked ${user.name}');
//           break;
//       }
//     });
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   Widget _buildActionButton() {
//     switch (user.friendshipStatus) {
//       case FriendshipStatus.notFriends:
//         return ElevatedButton.icon(
//           onPressed: () => _handleFriendAction(user.friendshipStatus),
//           icon: const Icon(Icons.pets, size: 18),
//           label: const Text('Add Friend'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.orange,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         );
//       case FriendshipStatus.requestSent:
//         return OutlinedButton.icon(
//           onPressed: () => _handleFriendAction(user.friendshipStatus),
//           icon: const Icon(Icons.check, size: 18),
//           label: const Text('Request Sent'),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: Colors.grey[700],
//             side: BorderSide(color: Colors.grey[300]!),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         );
//       case FriendshipStatus.requestReceived:
//         return ElevatedButton.icon(
//           onPressed: () => _handleFriendAction(user.friendshipStatus),
//           icon: const Icon(Icons.check_circle, size: 18),
//           label: const Text('Accept Request'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         );
//       case FriendshipStatus.friends:
//         return OutlinedButton.icon(
//           onPressed: () => _handleFriendAction(user.friendshipStatus),
//           icon: const Icon(Icons.check, size: 18),
//           label: const Text('Friends'),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: Colors.grey[700],
//             side: BorderSide(color: Colors.grey[300]!),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         );
//       case FriendshipStatus.blocked:
//         return ElevatedButton.icon(
//           onPressed: () => _handleFriendAction(user.friendshipStatus),
//           icon: const Icon(Icons.block, size: 18),
//           label: const Text('Unblock'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             pinned: true,
//             backgroundColor: Colors.orange,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     user.coverImage,
//                     fit: BoxFit.cover,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.3),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.more_vert),
//                 onPressed: () {
//                   _showOptionsMenu(context);
//                 },
//               ),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Transform.translate(
//                   offset: const Offset(0, -50),
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: CircleAvatar(
//                           radius: 60,
//                           backgroundImage: NetworkImage(user.profileImage),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         user.name,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.orange[100],
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${user.type == 'pet' ? '🐾' : '👤'} ${user.breed}',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.orange[800],
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Text(
//                           user.bio,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildStatItem(user.postsCount.toString(), 'Posts'),
//                           Container(
//                             height: 30,
//                             width: 1,
//                             color: Colors.grey[300],
//                             margin: const EdgeInsets.symmetric(horizontal: 20),
//                           ),
//                           _buildStatItem(user.friendsCount.toString(), 'Friends'),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       if (user.friendshipStatus != FriendshipStatus.blocked)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             children: [
//                               Expanded(child: _buildActionButton()),
//                               const SizedBox(width: 8),
//                               OutlinedButton.icon(
//                                 onPressed: () {},
//                                 icon: const Icon(Icons.message, size: 18),
//                                 label: const Text('Message'),
//                                 style: OutlinedButton.styleFrom(
//                                   foregroundColor: Colors.orange,
//                                   side: const BorderSide(color: Colors.orange),
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       if (user.friendshipStatus == FriendshipStatus.blocked)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: _buildActionButton(),
//                         ),
//                       const SizedBox(height: 20),
//                       if (user.mutualFriends.isNotEmpty &&
//                           user.friendshipStatus != FriendshipStatus.blocked)
//                         _buildMutualFriends(),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       _buildTabButton('Posts'),
//                       _buildTabButton('About'),
//                       _buildTabButton('Friends'),
//                     ],
//                   ),
//                 ),
//                 if (selectedTab == 'Posts') _buildPostsList(),
//                 if (selectedTab == 'About') _buildAboutSection(),
//                 if (selectedTab == 'Friends') _buildFriendsList(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String count, String label) {
//     return Column(
//       children: [
//         Text(
//           count,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMutualFriends() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.orange[50],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${user.mutualFriends.length} Mutual Friends',
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               ...user.mutualFriends.take(3).map((friend) => Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundImage: NetworkImage(friend.profileImage),
//                 ),
//               )),
//               if (user.mutualFriends.length > 3)
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.grey[300],
//                   child: Text(
//                     '+${user.mutualFriends.length - 3}',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabButton(String tab) {
//     bool isSelected = selectedTab == tab;
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             selectedTab = tab;
//           });
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: isSelected ? Colors.orange : Colors.transparent,
//                 width: 3,
//               ),
//             ),
//           ),
//           child: Text(
//             tab,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               color: isSelected ? Colors.orange : Colors.grey[600],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPostsList() {
//     if (user.friendshipStatus == FriendshipStatus.blocked) {
//       return _buildBlockedMessage();
//     }

//     return Column(
//       children: user.posts.map((post) => _buildPostCard(post)).toList(),
//     );
//   }

//   Widget _buildPostCard(Post post) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: NetworkImage(user.profileImage),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         _formatTimestamp(post.timestamp),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               post.content,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//           if (post.image != null) ...[
//             const SizedBox(height: 12),
//             Image.network(
//               post.image!,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ],
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text('${post.likes}', style: TextStyle(color: Colors.grey[600])),
//                 const SizedBox(width: 20),
//                 Icon(Icons.comment_outlined, size: 20, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text('${post.comments}', style: TextStyle(color: Colors.grey[600])),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAboutSection() {
//     if (user.friendshipStatus == FriendshipStatus.blocked) {
//       return _buildBlockedMessage();
//     }

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'About',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildInfoRow(Icons.pets, 'Type', user.type == 'pet' ? 'Pet' : 'Owner'),
//           _buildInfoRow(Icons.category, 'Breed', user.breed),
//           _buildInfoRow(Icons.description, 'Bio', user.bio),
//           _buildInfoRow(Icons.cake, 'Joined', 'March 2024'),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: Colors.orange),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFriendsList() {
//     if (user.friendshipStatus == FriendshipStatus.blocked) {
//       return _buildBlockedMessage();
//     }

//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.75,
//         ),
//         itemCount: user.mutualFriends.length,
//         itemBuilder: (context, index) {
//           final friend = user.mutualFriends[index];
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundImage: NetworkImage(friend.profileImage),
//                 ),
//                 const SizedBox(height: 8),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     friend.name,
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBlockedMessage() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.block, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'This profile is blocked',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Unblock to view their content',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   void _showOptionsMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.block, color: Colors.red),
//               title: const Text('Block User'),
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   user.friendshipStatus = FriendshipStatus.blocked;
//                 });
//                 _showSnackBar('${user.name} has been blocked');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.report),
//               title: const Text('Report Profile'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showSnackBar('Report submitted');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.link),
//               title: const Text('Copy Profile Link'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showSnackBar('Profile link copied');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.list),
//               title: const Text('View Blocked Pets'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const BlockedPetsScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BlockedPetsScreen extends StatefulWidget {
//   const BlockedPetsScreen({super.key});

//   @override
//   State<BlockedPetsScreen> createState() => _BlockedPetsScreenState();
// }

// class _BlockedPetsScreenState extends State<BlockedPetsScreen> {
//   List<User> blockedPets = DummyData.getBlockedPets();

//   void _unblockPet(String userId) {
//     setState(() {
//       blockedPets.removeWhere((pet) => pet.id == userId);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Pet unblocked successfully'),
//         duration: Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Blocked Pets'),
//         backgroundColor: Colors.orange,
//         elevation: 0,
//       ),
//       body: blockedPets.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.pets, size: 80, color: Colors.grey[300]),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No blocked pets',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'You haven\'t blocked any pets yet',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: blockedPets.length,
//               itemBuilder: (context, index) {
//                 final pet = blockedPets[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(16),
//                     leading: CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(pet.profileImage),
//                     ),
//                     title: Text(
//                       pet.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(
//                           pet.breed,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${pet.friendsCount} friends',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: ElevatedButton(
//                       onPressed: () => _unblockPet(pet.id),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                       ),
//                       child: const Text('Unblock'),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProfileScreen(userId: pet.id),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

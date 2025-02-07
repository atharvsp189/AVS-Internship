import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScienceStoriesListScreen extends StatefulWidget {
  @override
  _ScienceStoriesListScreenState createState() =>
      _ScienceStoriesListScreenState();
}

class _ScienceStoriesListScreenState extends State<ScienceStoriesListScreen> {
  List<dynamic> stories = [];
  List<String> likedPosts = [];

  @override
  void initState() {
    super.initState();
    loadNews();
    loadLikedPosts();
  }

  Future<void> loadNews() async {
    final String response =
        await rootBundle.loadString('assets/json/marathi-science-story.json');
    final data = json.decode(response);
    setState(() {
      stories = data['stories'];
    });
  }

  Future<void> loadLikedPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      likedPosts = prefs.getStringList('likedPosts') ?? [];
    });
  }

  Future<void> toggleLike(String title) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (likedPosts.contains(title)) {
        likedPosts.remove(title);
      } else {
        likedPosts.add(title);
      }
      prefs.setStringList('likedPosts', likedPosts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Science Stories'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LikedPostsScreen(likedPosts: likedPosts, story: stories),
                ),
              );
            },
          ),
        ],
      ),
      body: stories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final isLiked = likedPosts.contains(story['title']);
                return GestureDetector(
                  onTap: () {
                    // Navigate to ScienceStoriesDetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScienceStoriesDetailScreen(
                          story: story,
                          isLiked: isLiked,
                          toggleLike: () => toggleLike(story['title']),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image styled as a thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            story['imageUrl'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                story['title'],
                                style: TextStyle(color: Colors.grey[600]),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked ? Colors.red : null,
                                    ),
                                    onPressed: () => toggleLike(story['title']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ScienceStoriesDetailScreen extends StatelessWidget {
  final dynamic story;
  final bool isLiked;
  final VoidCallback toggleLike;

  ScienceStoriesDetailScreen({
    required this.story,
    required this.isLiked,
    required this.toggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the story image
              Image.network(
                story['imageUrl'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),

              // Display the story title or content
              Text(
                story["story"],
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              // Row for actions (like, share, etc.)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                    onPressed: toggleLike,
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Handle share functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ScienceStoriesDetailScreen extends StatelessWidget {
//   final dynamic story;
//   final bool isLiked;
//   final VoidCallback toggleLike;

//   ScienceStoriesDetailScreen(
//       {required this.story, required this.isLiked, required this.toggleLike});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(story['title']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               story['imageUrl'],
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 16),
//             Text(
//               story["story"],
//               style: TextStyle(
//                 fontSize: 18,
//                 height: 1.5,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: isLiked ? Colors.red : null),
//                   onPressed: toggleLike,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.share),
//                   onPressed: () {
//                     // Handle share functionality
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class LikedPostsScreen extends StatelessWidget {
  final List<String> likedPosts;
  final List<dynamic> story;

  LikedPostsScreen({required this.likedPosts, required this.story});

  @override
  Widget build(BuildContext context) {
    final likedArticles =
        story.where((story) => likedPosts.contains(story['title'])).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Posts'),
      ),
      body: likedArticles.isEmpty
          ? Center(child: Text('No liked posts yet!'))
          : ListView.builder(
              itemCount: likedArticles.length,
              itemBuilder: (context, index) {
                final story = likedArticles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScienceStoriesDetailScreen(
                          story: story,
                          isLiked: true,
                          toggleLike: () {},
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Image.network(story['imageUrl'],
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(story['title'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(story['title']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

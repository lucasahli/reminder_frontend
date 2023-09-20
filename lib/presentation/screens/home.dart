import 'package:flutter/material.dart';
import 'details.dart'; // Import the DetailsScreen
import '../services/api_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Call an API service to fetch data
    posts = await ApiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = posts[index];
          return ListTile(
            title: Text(post['title']),
            subtitle: Text(post['body']),
            onTap: () {
              // Navigate to the Details screen when a post is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(post: post),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

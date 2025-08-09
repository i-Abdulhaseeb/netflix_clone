import 'package:flutter/material.dart';
import 'package:netflix_clone/search.dart';
import 'package:netflix_clone/account_page.dart';
import 'package:netflix_clone/my_list_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Map<String, String>> trending = [
    {
      "title": "Dune",
      "imageUrl":
          "https://media.themoviedb.org/t/p/w600_and_h900_bestv2/ljsZTbVsrQSqZgWeep2B1QiDKuh.jpg",
    },
    {
      "title": "The Dark Knight",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/1hRoyzDtpgMU7Dz4JF22RANzQO7.jpg",
    },
    {
      "title": "Interstellar",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
    },
    {
      "title": "Avatar",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/6EiRUJpuoeQPghrs3YNktfnqOVh.jpg",
    },
  ];

  final List<Map<String, String>> topRated = [
    {
      "title": "The Godfather",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
    },
    {
      "title": "Pulp Fiction",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg",
    },
    {
      "title": "Shawshank Redemption",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
    },
    {
      "title": "Fight Club",
      "imageUrl":
          "https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg",
    },
  ];

  void toggleMyList(String title, String imageUrl) {
    setState(() {
      if (MyListManager.myList.any((item) => item["imageUrl"] == imageUrl)) {
        MyListManager.removeFromList(imageUrl);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Removed from My List")));
      } else {
        MyListManager.addToList(title, imageUrl);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Added to My List")));
      }
    });
  }

  Widget buildSection(String title, List<Map<String, String>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final isInList = MyListManager.myList.any(
                (item) => item["imageUrl"] == movie["imageUrl"],
              );

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 120,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        movie["imageUrl"]!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 180,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(
                          isInList ? Icons.check_circle : Icons.add_circle,
                          color: isInList ? Colors.green : Colors.white,
                        ),
                        onPressed: () =>
                            toggleMyList(movie["title"]!, movie["imageUrl"]!),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget homeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Image.network(
              "https://image.tmdb.org/t/p/w500/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          buildSection("Trending Now", trending),
          buildSection("Top Rated", topRated),
          if (MyListManager.myList.isNotEmpty)
            buildSection("My List", MyListManager.myList),
        ],
      ),
    );
  }

  Widget searchContent() {
    final Map<String, String> movies = {
      for (var movie in trending) movie["title"]!: movie["imageUrl"]!,
      for (var movie in topRated) movie["title"]!: movie["imageUrl"]!,
      for (var movie in MyListManager.myList)
        movie["title"]!: movie["imageUrl"]!,
    };

    return SearchPage(movies: movies);
  }

  Widget accountContent() {
    return AccountPage(myList: MyListManager.myList);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      homeContent(),
      searchContent(),
      accountContent(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "NETFLIX",
          style: TextStyle(
            color: Colors.red[600],
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png",
              ),
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red[600],
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

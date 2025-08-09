import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final Map<String, String> movies; // movieName -> imageURL

  const SearchPage({super.key, required this.movies});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    // Filter movies by query
    final results = widget.movies.entries.where((movie) {
      return movie.key.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search movies...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
      ),
      body: results.isEmpty
          ? const Center(
              child: Text(
                "No results found",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two per row
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final movie = results[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// account_page.dart
import 'package:flutter/material.dart';
import 'package:netflix_clone/my_list_manager.dart';

class AccountPage extends StatefulWidget {
  final List<Map<String, String>> myList; // passed from HomePage

  const AccountPage({super.key, required this.myList});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String userName = "John Doe";
  String userEmail = "johndoe@example.com";

  void _editProfile() {
    final nameController = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Name",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) userName = newName;
                });
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _openMyList() {
    // Push MyListPage and refresh when we come back (so count / UI updates)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyListPage(myList: MyListManager.myList),
      ),
    ).then((_) => setState(() {}));
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Account", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // profile
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png",
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(userEmail, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.white30),

          // My List row with count
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.white),
            title: const Text("My List", style: TextStyle(color: Colors.white)),
            trailing: Text(
              "${widget.myList.length}",
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: _openMyList,
          ),

          const Divider(color: Colors.white30),

          // Edit Profile
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
            onTap: _editProfile,
          ),

          // Security Settings
          ListTile(
            leading: const Icon(Icons.security, color: Colors.white),
            title: const Text(
              "Security Settings",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _showSnack("Security Settings tapped"),
          ),

          // Manage Subscription
          ListTile(
            leading: const Icon(Icons.subscriptions, color: Colors.white),
            title: const Text(
              "Manage Subscription",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _showSnack("Manage Subscription tapped"),
          ),

          // Help Center
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text(
              "Help Center",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _showSnack("Help Center tapped"),
          ),

          const Divider(color: Colors.white30),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () => _showSnack("Logged out"),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// My List page: shows posters + titles, allows removing items.
class MyListPage extends StatefulWidget {
  final List<Map<String, String>> myList;

  const MyListPage({super.key, required this.myList});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  late List<Map<String, String>> items;

  @override
  void initState() {
    super.initState();
    // create a local copy (backed by MyListManager.myList)
    items = List<Map<String, String>>.from(widget.myList);
  }

  void _removeItem(String imageUrl) {
    MyListManager.removeFromList(imageUrl);
    setState(() {
      items.removeWhere((it) => it["imageUrl"] == imageUrl);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Removed from My List")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "No items in My List",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = items[index];
                  final image = movie["imageUrl"]!;
                  final title = movie["title"] ?? "";
                  return GestureDetector(
                    onLongPress: () => _removeItem(image),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                                ),
                          ),
                        ),
                        Positioned(
                          left: 6,
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: InkWell(
                            onTap: () => _removeItem(image),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

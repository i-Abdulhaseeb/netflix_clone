class MyListManager {
  static List<Map<String, String>> myList = [];

  static void addToList(String title, String imageUrl) {
    if (!myList.any((item) => item["imageUrl"] == imageUrl)) {
      myList.add({"title": title, "imageUrl": imageUrl});
    }
  }

  static void removeFromList(String imageUrl) {
    myList.removeWhere((item) => item["imageUrl"] == imageUrl);
  }
}

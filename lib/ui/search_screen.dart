import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search_screen";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pencarian"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mau cari restoran apa?"),
                    ),
                    trailing:
                        IconButton(onPressed: () {}, icon: Icon(Icons.cancel)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

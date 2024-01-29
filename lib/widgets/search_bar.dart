import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';

typedef OnSearchTermChanged = Function(String searchTerm);

class SearchBar extends StatefulWidget {
  final OnSearchTermChanged onSearchTermChanged;

  const SearchBar({
    Key? key,
    required this.onSearchTermChanged,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
            color: Theme.of(context).colorScheme.secondary, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 2),
          )
        ],
      ),
      width: MediaQuery.of(context).size.width - 32,
      child: TextFormField(
        controller: _searchController,
        onFieldSubmitted: widget.onSearchTermChanged,
        style: Theme.of(context).textTheme.titleMedium,
        decoration: InputDecoration(
          hintText: "Mau belanja dimana?",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          contentPadding: const EdgeInsets.only(top: 20, bottom: 20),
          focusColor: primaryColor,
          prefixIcon: const Icon(
            Icons.search,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0.5, color: primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }
}

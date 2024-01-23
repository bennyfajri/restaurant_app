import 'package:flutter/material.dart';
import 'package:restaurant_app/util/constant.dart';

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
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF2F2F7), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDFE9F5).withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 2),
          )
        ],
      ),
      width: MediaQuery.of(context).size.width - 32,
      child: TextFormField(
        controller: _searchController,
        cursorColor: startColor,
        onFieldSubmitted: widget.onSearchTermChanged,
        style: Theme.of(context).textTheme.titleMedium,
        decoration: InputDecoration(
          hintText: "Mau belanja dimana?",
          contentPadding: const EdgeInsets.only(top: 20, bottom: 20),
          focusColor: startColor,
          prefixIcon: const Icon(
            Icons.search,
            color: inactive,
          ),
          // suffixIcon: _searchController.text.isNotEmpty ? IconButton(
          //   onPressed: widget.onSearchTermChanged(_searchController.text),
          //   icon: const Icon(Icons.search),
          // ) : null,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0.5, color: startColor),
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

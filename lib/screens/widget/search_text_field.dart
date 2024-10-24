import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key, required this.searchController,required this.hintText});

  final TextEditingController searchController;
  final String hintText;

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(1, 117, 215, 0.81),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(1, 117, 215, 0.81),
            width: 2.0,
          ),
        ),
        // Remove underline (set border to none)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(1, 117, 215, 0.81),
            width: 2.0,
          ),
        ),
      ),
      onChanged: (text) {
        // Optional: You can handle real-time text changes here if needed.
      },
    );
  }
}
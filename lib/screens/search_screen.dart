import "package:flutter/material.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Movies"), centerTitle: true),
      body:SafeArea(
        child:Padding(
            padding: EdgeInsets.all(16),
            child:  TextField(
              decoration: InputDecoration(
                hintText: "Empty PlaceHolder",
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
        ),
      ),
    );
  }
}

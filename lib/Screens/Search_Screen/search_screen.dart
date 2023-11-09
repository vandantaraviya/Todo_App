import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController();

  List<String> contacts = [
      'adil',
      'dean',
      'max',
      'aditya',
      'lucky',
      'leo',
      'james',
      'jack',
      'aadhya',
      'aaradhya',
      'dishita',
      'drishya',
      'hiya',
      'banni',
      'priyanshi',
  ];

  List<String> filteredDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredDataList.addAll(contacts);
  }

  void filterSearchResults(String query) {
    List<String> searchResults = [];
    searchResults.addAll(contacts);
    if (query.isNotEmpty) {
      searchResults.retainWhere((item) => item.toLowerCase().contains(query.toLowerCase()));
    }
    setState(() {
      filteredDataList.clear();
      filteredDataList.addAll(searchResults);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Screen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: search,
              onChanged: filterSearchResults,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredDataList[index]),
                  onTap: (){},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Screens/Search_Screen/search_controller.dart';
import 'package:todo_app/utils/Common/app_string.dart';
import 'package:todo_app/utils/Common_Widgets/custom_textfiled.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());

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
              controller: searchController.search,
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

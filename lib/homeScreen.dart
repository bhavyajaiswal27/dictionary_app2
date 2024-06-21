import 'package:dictionary_app/dictionary_model.dart';
import 'package:dictionary_app/services.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DictionaryModel ?_myDictionaryModel;
  bool isloading = false;
  String nodatafound = "Now you can search";
  searchContain(String word) async {
    setState(() {});
    try {
      _myDictionaryModel = await ApiServices.fetchData(word);
    } catch (e) {
      // 
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dictionay'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(

        ),
        ),
    );
  }
}// import 'package:';


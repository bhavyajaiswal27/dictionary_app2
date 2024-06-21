import 'package:dictionary_app/dictionary_model.dart';
import 'package:dictionary_app/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DictionaryModel? _myDictionaryModel;
  bool isLoading = false;
  String noDataFound = "Now you can search";

  searchContain(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      _myDictionaryModel = await ApiServices.fetchData(word);
    } catch (e) {
      _myDictionaryModel = null;
      noDataFound = "Meaning can't be found";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              hintText: "Search the text here",
              onSubmitted: (value) {
                searchContain(value);
              },
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.brown),
              )
            else if (_myDictionaryModel != null)
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      _myDictionaryModel!.word ?? "No word found",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(_myDictionaryModel!.phonetics != null && _myDictionaryModel!.phonetics!.isNotEmpty
                        ? _myDictionaryModel!.phonetics![0].text ?? ""
                        : ""),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return showMeaning(_myDictionaryModel!.meanings![index]);
                      },
                      itemCount: _myDictionaryModel!.meanings!.length,
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    noDataFound,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget showMeaning(Meanings meaning) {
    String wordDefinition = "";
    for (var element in meaning.definitions!) {
      int index = meaning.definitions!.indexOf(element);
      wordDefinition += "\n${1 + index}.${element.definition}\n";
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech ?? "No part of speech",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 22),
              ),
              const SizedBox(height: 10),
              const Text("Definition: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18)),
              Text(
                wordDefinition,
                style: const TextStyle(fontSize: 16, height: 1),
              ),
              wordRelation("Synonyms", meaning.synonyms),
              wordRelation("Antonyms", meaning.antonyms),
            ],
          ),
        ),
      ),
    );
  }

  Widget wordRelation(String title, List<String>? setList) {
    if (setList != null && setList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            setList.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

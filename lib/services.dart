import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dictionary_app/dictionary_model.dart';

class ApiServices {
  static String baseurl = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  static Future <DictionaryModel?> fetchData (String word) async {
    Uri url = Uri.parse("$baseurl$word");
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DictionaryModel.fromJson(data[0]);
      }
      else {
        throw("failed to load");
      }
    } catch (e) {
      print(e.toString());
    }
  } 
}
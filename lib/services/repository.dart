import 'dart:convert';

import 'package:fit_page/models/main_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Repository {
  static const String url = 'https://mobile-app-challenge.herokuapp.com/data';

  /// Function to fetch list of [MainModel]
  Future<List<MainModel>?> getData() async {
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List<dynamic>;
      final list = <MainModel>[];
      for (final i in data) {
        final model = MainModel.fromJson(json: i as Map<String, dynamic>);
        list.add(model);
      }
      Fluttertoast.showToast(msg: 'Fetched successfully');
      return list;
    }
    Fluttertoast.showToast(msg: 'Fetch failed');
    return null;
  }
}

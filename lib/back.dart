import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Back extends ChangeNotifier{
  Map<String,dynamic> transformedPaths={};
  bool loading=false;
  double progress=0.0;

  void transform(List<String> paths)async{
    loading=true;
    transformedPaths={};
    progress=0.0;
    notifyListeners();
    int i=0;
    String t=DateTime.now().millisecondsSinceEpoch.toString();
    for (var element in paths) {
        var res=await transformCall(element, t);
        // debugPrint(res.body.toString());
        transformedPaths[(element.split('.')[0])]=res.body;
        debugPrint(transformedPaths.toString());
        i+=1;
        progress=i/(paths.length);
        notifyListeners();
      }
      loading=false;
      progress=0.0;
    notifyListeners();
  }
  Future<http.Response> transformCall(String path, String fold) {
    return http.post(
      Uri.parse('http://localhost:5000/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'path': path,
        'fold':fold
      }),
    );
  }
}
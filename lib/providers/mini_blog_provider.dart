import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniblog/models/mini_blog_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final blogProvider = FutureProvider<List<Blog>>((ref) async {
  final response = await http
      .get(Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles"));
  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((item) => Blog.fromJson(item)).toList();
  } else {
    throw Exception('Bloglar Görüntülenemedi');
  }
});

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list_app/models/shopping_item.dart';

class StorageService {
  static const _key = 'shopping_items';

  Future<List<ShoppingItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if(data == null)
      return [];

    final list = jsonDecode(data) as List;
    return list.map((e) => ShoppingItem.fromMap(e)).toList();  
  }

  Future<void> saveItems(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final json =  jsonEncode(items.map((e) => e.toMap()).toList());

    await prefs.setString(_key, json);
  }
}
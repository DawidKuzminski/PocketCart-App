import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_list_app/models/dtos/shopping_item_dto.dart';
import 'package:shopping_list_app/models/dtos/shopping_list_dto.dart';
import 'package:shopping_list_app/models/shopping_list.dart';

class CartRemoteDataSource {
  final http.Client client;
  final String baseUrl = '10.0.2.2:5038';
  final String baseEndpoint = 'carts';

  CartRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  Future<List<ShoppingListDto>> getCarts() async {
    var url = Uri.http(baseUrl, 'carts');

    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ShoppingListDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shopping lists');
      }
    } catch (e) {
      throw Exception('Error fetching shopping lists: $e');
    }
  }

  Future<List<ShoppingItemDto>> getCartItemsAsync(String id) async {
    var url = Uri.http(baseUrl, 'carts/$id/items');

    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ShoppingItemDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shopping items');
      }
    } catch (e) {
      throw Exception('Error fetching shopping items: $e');
    }
  }

  Future<void> addCart(ShoppingListDto cart) async {
      var url = Uri.http(baseUrl, 'carts');
      try {
        var response = await client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(cart.toJson()),
        );
        if (response.statusCode != 201) {
          throw Exception('Failed to add shopping list');
        }
      } catch (e) {
        throw Exception('Error adding shopping list: $e');
      }
  }

  Future<void> deleteCartAsync(String id) async {
    var url = Uri.http(baseUrl, 'carts/$id');
    try {
      var response = await client.delete(url);
      if(response.statusCode != 200) {
        throw Exception('Failed to remove shopping list');
      }
    } catch(e) {
      throw Exception('Error deleting shopping list: $e');
    }
  }

  Future<void> updateCartAsync(String id, ShoppingListDto updatedCart) async {
    var url = Uri.http(baseUrl, 'carts/$id');
    try {
      var response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCart.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update shopping list');
      }
    } catch (e) {
      throw Exception('Error updating shopping list: $e');
    }
  }
}
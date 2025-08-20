import 'package:http/http.dart' as http;
import 'package:shopping_list_app/models/shopping_list.dart';

class ShoppingListRemoteDataSource {

  Future<void> fetchAll() async {
    const String baseUrl = '10.0.2.2:5038';
    var url = Uri.http(baseUrl, 'carts');
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
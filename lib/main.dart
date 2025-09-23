import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_list_app/bloc/category/category_bloc.dart';
import 'package:shopping_list_app/bloc/category/category_event.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';
import 'package:shopping_list_app/data/cart_remote_data_source.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/router/router.dart';
import 'package:shopping_list_app/data/category_repository.dart';
import 'package:shopping_list_app/data/cart_local_data_source.dart';
import 'package:http/http.dart' as http;

late final CartRemoteDataSource remoteDataSource;
late final CartLocalDataSource cartLocalDataSource;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ShoppingItemAdapter()); 
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<ShoppingList>('shopping_lists');
  await Hive.openBox<Category>('shopping_categories');

  final httpClient = http.Client();
  remoteDataSource = CartRemoteDataSource(client: httpClient);
  cartLocalDataSource = CartLocalDataSource();

  final categoryService = CategoryRepository();
  
  runApp(
    MyApp(
      cartLocalDataSource: cartLocalDataSource,
      categoryService: categoryService));
}

class MyApp extends StatelessWidget {
  final CartLocalDataSource cartLocalDataSource;
  final CategoryRepository categoryService;

  const MyApp({super.key, required this.cartLocalDataSource, required this.categoryService});

  @override
  Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ShoppingListBloc(cartLocalDataSource)..add(LoadLists()),
          ),
          BlocProvider(
            create: (_) => CategoriesBloc(categoryService)..add(Load()),
          ),
        ],
        child: MaterialApp.router(
        routerConfig: router,
        ),
      );
    }
}
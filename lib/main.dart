import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_list_app/bloc/category/category_bloc.dart';
import 'package:shopping_list_app/bloc/category/category_event.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/router/router.dart';
import 'package:shopping_list_app/services/category_repository.dart';
import 'package:shopping_list_app/services/shopping_list_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ShoppingItemAdapter()); 
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<ShoppingList>('shopping_lists');
  await Hive.openBox<Category>('shopping_categories');

  final shoppingListService = ShoppingListService();
  final categoryService = CategoryRepository();
  
  runApp(
    MyApp(
      shoppingListService: shoppingListService,
      categoryService: categoryService));
}

class MyApp extends StatelessWidget {
  final ShoppingListService shoppingListService;
  final CategoryRepository categoryService;

  const MyApp({super.key, required this.shoppingListService, required this.categoryService});

  @override
  Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ShoppingListBloc(shoppingListService)..add(LoadLists()),
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
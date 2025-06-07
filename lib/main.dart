import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/services/shopping_list_repository.dart';

import 'screens/shopping_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ShoppingItemAdapter()); 
  Hive.registerAdapter(ShoppingListAdapter());
  await Hive.openBox<ShoppingList>('shopping_lists');

  final shoppingListService = ShoppingListService();
  
  runApp(MyApp(shoppingListService: shoppingListService));
}

class MyApp extends StatelessWidget {
  final ShoppingListService shoppingListService;

  const MyApp({super.key, required this.shoppingListService});

  @override
  Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ShoppingListBloc(shoppingListService)..add(LoadLists()),
          ),
        ],
        child: const MaterialApp(
        home: ShoppingListScreen(),
        ),
      );
    }
}
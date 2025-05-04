import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_event.dart';
import 'package:shopping_list_app/screens/home_screen.dart';
import 'package:shopping_list_app/services/storage_service.dart';

void main() {
  final storageService = StorageService();
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lista zakupów",
      home: BlocProvider(
        create: (_) => ShoppingBloc(storageService)..add(LoadItems()),
        child: HomeScreen(),
      ),
    );    
  }
}
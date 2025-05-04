import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_event.dart';
import 'package:shopping_list_app/bloc/shopping_state.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/widgets/shopping_item_tile.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final uuid = const Uuid();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista zakupów")),
      body: BlocBuilder<ShoppingBloc, ShoppingState>(
        builder: (context, state) {
          return ListView(
            children: state.items
              .map((item) => ShoppingItemTile(item: item))
              .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton (
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nowy produkt"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "np. Mleko"),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(hintText: "Ilość: np. 3"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
              if(name.isNotEmpty) {
                final item = ShoppingItem(id: uuid.v4(), name: name, quantity: quantity);
                context.read<ShoppingBloc>().add(AddItem(item));
              }
              _controller.clear();
              Navigator.pop(context);
            }, 
            child: const Text("Dodaj"),
          )
        ],
      )
    );
  }
}
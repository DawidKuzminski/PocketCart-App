import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';

import 'package:shopping_list_app/models/shopping_item.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final String listId;

  const ShoppingItemTile({super.key, required this.item, required this.listId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${item.name} (${item.quantity} szt.)",
        style: TextStyle(
          decoration: item.isBought ? TextDecoration.lineThrough : null
        ),
      ),
      leading: Checkbox(
        value: item.isBought,
        onChanged: (_) => context.read<ShoppingListBloc>().add(ToggleItemInList(listId, item.id))
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditItemDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<ShoppingListBloc>().add(RemoveItemFromList(listId, item.id))
          ),
        ],
      ) 
    );
  }

  void _showEditItemDialog(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(text: item.quantity.toString());
    final categoryController = ValueNotifier<String>(item.category);
    final List<String> categories = ['Nabiał', 'Warzywa', 'Mięso', 'Pieczywo', 'Inne'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edytuj produkt"),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nazwa"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Ilość"),
                ),
                DropdownButtonFormField(
                  value: categoryController.value,
                  items: categories
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                  onChanged: (value) {
                    if(value != null) {
                      categoryController.value = value;
                    }
                  },

                  decoration: const InputDecoration(labelText: "Kategoria"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
              final category = categoryController.value;
              if (name.isNotEmpty) {
                  context.read<ShoppingListBloc>().add(UpdateItemInList(listId, ShoppingItem(                  
                  id: item.id,
                  name: name,
                  quantity: quantity,
                  category: category,
                  isBought: item.isBought
                )));
              }
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Zapisz"),
          )
        ],
      ),
    );
  }
}
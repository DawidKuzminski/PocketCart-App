import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_bloc.dart';
import 'package:shopping_list_app/bloc/shopping_event.dart';
import 'package:shopping_list_app/models/shopping_item.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingItemTile({super.key, required this.item});

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
        onChanged: (_) => context.read<ShoppingBloc>().add(ToggleItem(item.id))
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => context.read<ShoppingBloc>().add(RemoveItem(item.id))
        ),        
      );
  }
}
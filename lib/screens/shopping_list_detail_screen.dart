import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_list_app/bloc/category/category_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_state.dart';
import 'package:shopping_list_app/models/routes.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/widgets/shopping_item_tile.dart';
import 'package:uuid/uuid.dart';

class ShoppingListDetailScreen extends StatelessWidget {
  final String name;
  final String listId;
  String _lastUsedCategory = "";

  ShoppingListDetailScreen({
    super.key,
    required this.name,
    required this.listId
  });

  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista zakupów"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.push(
              Routes.homePage,
            );
          },
        ),
      ),
      body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          final notBoughtByCategory = <String, List<ShoppingItem>>{};
          final boughtByCategory = <String, List<ShoppingItem>>{};
          final list = state.lists.firstWhere(
            (l) => l.id == listId,
            orElse: () => ShoppingList(id: listId, name: name));

            final items = list.items;
            if (items.isEmpty) {
              return const Center(child: Text("Brak produktów w tej liście."));
          }

          for (final item in items) {
            if(item.isBought) {
              boughtByCategory.putIfAbsent(item.category, () => []).add(item);
            } else {
              notBoughtByCategory.putIfAbsent(item.category, () => []).add(item);
            }
          }

          final widgets = <Widget>[];
          widgets.add(const Divider());
          widgets.add(const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Do kupienia",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.amberAccent),
            ),
          ));

          for (final category in notBoughtByCategory.keys) {
            final items = notBoughtByCategory[category]!;
            widgets.add(Padding(
              padding: const EdgeInsets.all(8),
              child: Text(category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ));
             widgets.addAll(items.map((i) => ShoppingItemTile(item: i, listId: listId)));
          }

          widgets.add(const Divider());

          widgets.add(const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Kupione",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.greenAccent),
            ),
          ));
          
            for (final category in boughtByCategory.keys) {
            final items = boughtByCategory[category]!;
            widgets.add(Padding(
              padding: const EdgeInsets.all(8),
              child: Text(category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ));
             widgets.addAll(items.map((i) => ShoppingItemTile(item: i, listId: listId)));
          }    

          return ListView(children: widgets);          
        },
      ),
      floatingActionButton: FloatingActionButton (
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final categories = context.read<CategoriesBloc>().state.categories;
    
    final categoriesAsString = categories
      .map((category) => DropdownMenuItem(
        value: category.name, 
        child: Text(category.name)
      ))
      .toList();

    final initialCategory = _lastUsedCategory.isNotEmpty
      ? _lastUsedCategory
      : categories.isNotEmpty
        ? categories.first.name
        : 'Inne';

    final categoryController = ValueNotifier(initialCategory);
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
              decoration: const InputDecoration(labelText: "Nazwa", hintText: "np. Mleko"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Ilość", hintText: "Ilość: np. 3"),
            ),
            DropdownButtonFormField(
              value: categoryController.value,
              items: categoriesAsString,
              onChanged: (value) {
                if(value != null && value is String) {
                  categoryController.value = value;
                }
              },

              decoration: const InputDecoration(labelText: "Kategoria"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
              final category = categoryController.value;

              if(name.isNotEmpty) {
                final item = ShoppingItem(id: uuid.v4(), name: name, quantity: quantity, category: category);
                context.read<ShoppingListBloc>().add(AddItemToList(listId, item));
              }
              _lastUsedCategory = categoryController.value;
              Navigator.of(context, rootNavigator: true).pop();
            }, 
            child: const Text("Dodaj")
          )
        ],
      )
    );
  }
}
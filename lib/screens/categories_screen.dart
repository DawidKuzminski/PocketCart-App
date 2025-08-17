import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/category/category_bloc.dart';
import 'package:shopping_list_app/bloc/category/category_event.dart';
import 'package:shopping_list_app/bloc/category/category_state.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:uuid/uuid.dart';
import 'package:shopping_list_app/models/category.dart' as model;

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  final uuid = const Uuid();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorie'),
      ),
      body: BlocBuilder<CategoriesBloc, CategoryState>(
        builder: (context, state) {
          final categories = state.categories;
          if(categories.isEmpty) {
            context.read<CategoriesBloc>().add(Add(model.Category(id: uuid.v4(), name: 'Inne')));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final row = categories[index];

              return ListTile(
                title: Text(row.name),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if(value == 'edit') {
                      _showEditCategoryDialog(context, category: row);
                    } else if (value == 'delete') {
                      context.read<CategoriesBloc>().add(Delete(row.id));
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edytuj')),
                    const PopupMenuItem(value: 'delete', child: Text('Usuń'))
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
           _showAddCategoryDialog(context);
        },),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nowa kategoria"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nazwa", hintText: "nazwa kategorii")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if(name.isNotEmpty)
              {
                context.read<CategoriesBloc>().add(Add(model.Category(id: uuid.v4(), name: name)));
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: const Text("Dodaj"))
        ],
      ));
  }

  void _showEditCategoryDialog(BuildContext context, {required model.Category category}) {
    final nameController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edytuj kategorie"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nazwa", hintText: "nazwa kategorii")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if(name.isNotEmpty)
              {
                context.read<CategoriesBloc>().add(Update(category.id, model.Category(id: category.id, name: name)));
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: const Text("Zapisz"))
        ],
      ));
  }
}
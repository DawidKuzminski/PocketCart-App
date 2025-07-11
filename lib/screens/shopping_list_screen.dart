import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_bloc.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_event.dart';
import 'package:shopping_list_app/bloc/shoppingList/shopping_list_state.dart';
import 'package:shopping_list_app/models/routes.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/screens/shopping_list_detail_screen.dart';
import 'package:uuid/uuid.dart';

class ShoppingListScreen extends StatelessWidget
{
  const ShoppingListScreen({super.key});
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Listy zakupowe')),
          body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
            builder: (context, state) {
              final lists = state.lists;
              if(lists.isEmpty) {
                return const Center(child: Text('Brak zapisanych list'));
              }

              return ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final list = lists[index];

                  return ListTile(
                    title: Text(list.name),
                    onTap: () => context.push(
                      Routes.homeDetails,
                      extra: {'name': list.name, 'listId': list.id}
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if(value == 'edit') {
                          _showEditListDialog(context, selectedList: list);
                        } else if (value == 'delete') {
                          context.read<ShoppingListBloc>().add(DeleteList(list.id));
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
            onPressed: () {
              _showAddListDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
  }

  void _showAddListDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nowa lista"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nazwa", hintText: "nazwa listy"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final list = ShoppingList(id: uuid.v4(), name: name);

                final bloc = context.read<ShoppingListBloc>();
                Navigator.of(context, rootNavigator: true).pop();

                Future.microtask(() {
                  bloc.add(AddList(list));
                  context.push(
                    Routes.homeDetails,
                    extra: {'name': list.name, 'listId': list.id},
                  );
                });
              }
            },
            child: const Text("Dodaj")
          )
        ],
      )
    );
  }

  void _showEditListDialog(BuildContext context, {required ShoppingList selectedList}) {
    final nameController = TextEditingController(text: selectedList.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edytuj liste"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nazwa", hintText: "nazwa listy"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if(name.isNotEmpty) {
                context.read<ShoppingListBloc>().add(UpdateList(selectedList.id, name));
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: const Text("Zapisz")
          )
        ],
      )
    );
  }
}
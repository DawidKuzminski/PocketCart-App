import 'package:hive/hive.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/models/shopping_list.dart';
import 'package:shopping_list_app/services/shopping_list_repository.dart';

class ShoppingListLocalDataSource {
  static final ShoppingListLocalDataSource _instance = ShoppingListLocalDataSource._internal();
  factory ShoppingListLocalDataSource() => _instance;
  ShoppingListLocalDataSource._internal();

  final Box<ShoppingList> _box = Hive.box<ShoppingList>('shopping_lists');

  List<ShoppingList> getAllList() => _box.values.toList();

  Future<void> addList(ShoppingList list) async {
    await _box.add(list);
  }

  Future<void> deleteListById(String id) async {
    final index = _box.values.toList().indexWhere((i) => i.id == id);
    if(index != -1) {
        await _box.deleteAt(index);
    }        
  }

  Future<void> updateListById(String id, ShoppingList updateList) async {
    final index = _box.values.toList().indexWhere((i) => i.id == id);
    if(index != -1) {
        await _box.putAt(index, updateList);
    }
  }

  ShoppingList? getReadonlyListById(String id) {
    try {
        return _box.values.firstWhere((l) => l.id == id);
    } catch (e) {
        return null;
    }
  }

  ShoppingList? getEditableListById(String id) {
    final index = _box.values.toList().indexWhere((l) => l.id == id);
    return index != -1 ? _box.getAt(index) : null;
  }

   List<ShoppingItem> getItems(String listId) {
    final list = getReadonlyListById(listId);
    if(list != null) {
      return list.items;
    }
      return [];
   }

  Future<void> addItemToList(String listId, ShoppingItem item) async {
    final list = getEditableListById(listId);
    if(list == null) return;
   
    final updatedItems = List<ShoppingItem>.from(list.items)..add(item);
    final updatedList = ShoppingList(
      id: list.id,
      name: list.name,
      items: updatedItems,
    );

    await updateListById(listId, updatedList);
  }

  Future<void> updateItem(String listId, ShoppingItem updatedItem) async {
    final list = getEditableListById(listId);
    if (list == null) return;

    final index = list.items.indexWhere((i) => i.id == updatedItem.id);
    if (index == -1) return;

    list.items[index] = updatedItem;

    await updateListById(listId, list);
  }

  Future<void> toggleItem(String listId, String itemId) async {
    final list = getEditableListById(listId);
    if (list == null) return;

    final index = list.items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final currentItem = list.items[index];
    final toggledItem = ShoppingItem(
      id: currentItem.id,
      name: currentItem.name,
      category: currentItem.category,
      quantity: currentItem.quantity,
      isBought: !currentItem.isBought);

      list.items[index] = toggledItem;

    await updateListById(listId, list);
  }

  Future<void> deleteItem(String listId, String itemId) async {
    final index = _box.values.toList().indexWhere((l) => l.id == listId);
    if (index == -1) return; 

    final list = _box.getAt(index);
    if (list == null) return;

    final updatedItems = list.items.where((item) => item.id != itemId).toList();
    final updatedList = ShoppingList(
      id: list.id,
      name: list.name,
      items: updatedItems,
    );

    await _box.putAt(index, updatedList);
  }

  Future<void> clearAll() async {
    _box.clear();
  }

  int findIndexById(String id) {
    final items = _box.values.toList();
    return items.indexWhere((item) => item.id == id);
  }
}
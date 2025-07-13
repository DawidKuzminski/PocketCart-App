import 'package:hive/hive.dart';
import 'package:shopping_list_app/models/category.dart';

class CategoryRepository {
  final Box<Category> _box = Hive.box<Category>('shopping_categories');

  List<Category> getAll() => _box.values.toList();

  Future<void> addAsync(Category category) async {
    await _box.add(category);
  }

  Future<void> deleteByIdAsync(String id) async {
    final index = _box.values.toList().indexWhere((i) => i.id == id);
    if(index != -1) {
      await _box.deleteAt(index);
    }
  }

  Future<void> updateAtIdAsync(String id, Category updated) async {
    final index = _box.values.toList().indexWhere((i) => i.id == id);
    if(index != -1) {
      await _box.putAt(index, updated);
    }
  }

  Category? getEditableListById(String id) {
    final index = _box.values.toList().indexWhere((l) => l.id == id);
    return index != -1 ? _box.getAt(index) : null;
  }
}
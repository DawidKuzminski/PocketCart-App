import 'package:shopping_list_app/models/category.dart';

abstract class CategoriesEvent {}

class Load extends CategoriesEvent {}

class Add extends CategoriesEvent {
  final Category category;
  Add(this.category);
}

class Delete extends CategoriesEvent {
  final String id;
  Delete(this.id);
}

class Update extends CategoriesEvent {
  final String id;
  final Category category;
  Update(this.id, this.category);
}
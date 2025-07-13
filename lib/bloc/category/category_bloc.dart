import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_app/bloc/category/category_event.dart';
import 'package:shopping_list_app/bloc/category/category_state.dart';
import 'package:shopping_list_app/services/category_repository.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoryState> {
  final CategoryRepository storage;

  CategoriesBloc(this.storage) : super(CategoryState(categories: [])) {
    on<Load>((event, emit) {
      emit(CategoryState(categories: storage.getAll()));
    });

    on<Add>((event, emit) async {
      await storage.addAsync(event.category);
      emit(CategoryState(categories: storage.getAll()));
    });

    on<Delete>((event, emit) async {
      await storage.deleteByIdAsync(event.id);
      emit(CategoryState(categories: storage.getAll()));
    });

    on<Update>((event, emit) async {
      final current = storage.getEditableListById(event.id);
      if(current == null) return;

      await storage.updateAtIdAsync(event.id, event.category);
      emit(CategoryState(categories: storage.getAll()));
    });
  }
  
}
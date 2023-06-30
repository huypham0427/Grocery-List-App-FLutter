import 'package:flutter_bloc/flutter_bloc.dart';
import 'grocery_list_event.dart';
import 'grocery_list_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  GroceryListBloc() : super(GroceryListState(groceryList: <String>[])) {
    // Load the grocery list from shared preferences when the bloc is created
    loadGroceryList();
  }

  Future<void> loadGroceryList() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final groceryList = sharedPreferences.getStringList('groceryList') ?? [];
    add(GroceryListLoaded(groceryList: groceryList));
  }

  Future<void> saveGroceryList(List<String> groceryList) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList('groceryList', groceryList);
  }

  @override
  Stream<GroceryListState> mapEventToState(GroceryListEvent event) async* {
    if (event is AddItemEvent) {
      final groceryList = List<String>.from(state.groceryList)..add(event.item);
      yield GroceryListState(groceryList: groceryList);
      saveGroceryList(groceryList);
    } else if (event is DeleteItemEvent) {
      final groceryList = List<String>.from(state.groceryList)
        ..remove(event.item);
      yield GroceryListState(groceryList: groceryList);
      saveGroceryList(groceryList);
    } else if (event is EditItemEvent) {
      final groceryList = List<String>.from(state.groceryList);
      final index = groceryList.indexOf(event.oldItem);
      groceryList[index] = event.newItem;
      yield GroceryListState(groceryList: groceryList);
      saveGroceryList(groceryList);
    } else if (event is GroceryListLoaded) {
      yield GroceryListState(groceryList: event.groceryList);
    }
  }
}

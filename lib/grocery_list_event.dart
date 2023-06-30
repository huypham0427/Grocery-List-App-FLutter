import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class GroceryListEvent extends Equatable {
  const GroceryListEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends GroceryListEvent {
  final String item;

  const AddItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class DeleteItemEvent extends GroceryListEvent {
  final String item;

  const DeleteItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class EditItemEvent extends GroceryListEvent {
  final String oldItem;
  final String newItem;

  const EditItemEvent(this.oldItem, this.newItem);

  @override
  List<Object> get props => [oldItem, newItem];
}

class GroceryListLoaded extends GroceryListEvent {
  final List<String> groceryList;

  const GroceryListLoaded({required this.groceryList});

  @override
  List<Object> get props => [groceryList];
}

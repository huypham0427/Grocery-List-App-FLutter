import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'grocery_list_bloc.dart';
import 'grocery_list_event.dart';
import 'grocery_list_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      home: BlocProvider(
        create: (context) => GroceryListBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  int editingIndex = -1;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groceryListBloc = BlocProvider.of<GroceryListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        centerTitle: true,
      ),
      body: BlocBuilder<GroceryListBloc, GroceryListState>(
        builder: (context, state) {
          final groceryList = state.groceryList;
          return ListView.builder(
            itemCount: groceryList.length,
            itemBuilder: (context, index) {
              final item = groceryList[index];

              return ListTile(
                title: editingIndex == index
                    ? TextFormField(
                        controller: _textEditingController,
                        autofocus: true,
                        onFieldSubmitted: (value) {
                          groceryListBloc.add(EditItemEvent(item, value));
                          setState(() {
                            editingIndex = -1;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Edit Item',
                        ),
                      )
                    : Text(
                        item,
                        style: TextStyle(fontSize: 18.0),
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (editingIndex != index)
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            editingIndex = index;
                            _textEditingController.text = item;
                          });
                        },
                      ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        groceryListBloc.add(DeleteItemEvent(item));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final addItemEvent = AddItemEvent('New Item');
          groceryListBloc.add(addItemEvent);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

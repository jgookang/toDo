import 'package:flutter/material.dart';
import 'DataStorage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


//List<ToDoItem> _toDos = <ToDoItem>[
//  ToDoItem('Meeting 10:00 am'),
//  ToDoItem('Lunch 12:00 am'),
//  ToDoItem('Meeting 3:00 pm'),
//  ToDoItem('Dinner 7:00 pm'),
//];


class _ModalWidget extends StatelessWidget {
  final Widget child;

  _ModalWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        duration: const Duration(microseconds: 300),
        padding: mediaQuery.viewInsets,
        child: child);
  }
}


class _MyHomePageState extends State<MyHomePage> {
  final _textEditingController = TextEditingController();
  final _dataStorage = DataStorage();
  List<ToDoItem> _toDos = <ToDoItem>[];

  @override
  void initState(){
    super.initState();
    // todo:load
    _dataStorage.readData().then((value) => {
      setState((){
        _toDos = value;
      })
    } );
  }

  _addTask() async {
    await showDialog<String>(
      context: context,
      child: new _ModalWidget(
          child: new AlertDialog(
            content: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextField(
                          controller: _textEditingController,
                          autofocus: true,
                          decoration: new InputDecoration(labelText: 'Add a task', hintText: 'Adding new task')))
                ]
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () async {
                    setState(() {
                      print ( _textEditingController.text);
                      _toDos.add(ToDoItem(_textEditingController.text));
                      _dataStorage.writeData(_toDos);
                      _textEditingController.text = '';
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add')),
              new FlatButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text('Cancel'))
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final toDo = _toDos[index].title;
            return Dismissible(
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              key: Key(toDo),
              onDismissed: (direction) {
                setState(() {
                  _toDos.removeAt(index);
                  _dataStorage.writeData(_toDos);
                });
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$toDo Done")));
              },
              child: ListTile(
                title: Text(toDo),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: _toDos.length),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add a task',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
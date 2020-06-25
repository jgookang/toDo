import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'toDo Home Page'),
    );
  }
}

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

class _MyHomePageState extends State<MyHomePage> {
  final _textEditingController = TextEditingController();
  final _dataStorage = DataStorage();
  @override
  void initState(){
    super.initState();
    // todo:load
    _dataStorage.readData().then((value) => {
      setState((){
        _toDos =value;
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
                        _dataStorage.writeData();
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
                  _dataStorage.writeData();
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

class ToDoItem {
  const ToDoItem(this.title);

  final String title;

  factory ToDoItem.fromJson(Map<String, dynamic> json){
    return ToDoItem(json['title'] as String);
  }


  Map toJson() =>
      {
        'title': title,
      };
}

List<ToDoItem> _toDos = <ToDoItem>[
//  ToDoItem('Meeting 10:00 am'),
//  ToDoItem('Lunch 12:00 am'),
//  ToDoItem('Meeting 3:00 pm'),
//  ToDoItem('Dinner 7:00 pm'),
];

class DataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<ToDoItem>> readData() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      var list = jsonDecode(contents) as List;
      var toDoList = list.map((v) => ToDoItem.fromJson(v)).toList();

      return toDoList;
    } catch (e) {
      debugPrint(e.toString());
      return List<ToDoItem>();
    }
  }

  Future<File> writeData() async {
    final file = await _localFile;
    String contents = jsonEncode(_toDos);
    // Write the file
    return file.writeAsString(contents);
  }
}
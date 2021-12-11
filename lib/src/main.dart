import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'addlistpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List subscriptionItems = [];
  Map subscriptionItem = {};
  _setListText () async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      var item = prefs.getStringList("toDoList");
      if (item != null){
        subscriptionItems = prefs.getStringList("toDoList");
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _setListText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDoリスト'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: subscriptionItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionExtentRatio: 0.2,
            actionPane: SlidableDrawerActionPane(),
            actions: [
            ],
            secondaryActions: [
              IconSlideAction(
                caption: '削除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('削除しました'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  setState(() {
                    subscriptionItems.removeAt(index);
                  });
                  saveData(subscriptionItems);
                },
              )
            ],
            key: ValueKey(subscriptionItems[index]),
            child: Card(
              child: ListTile(
                title: Text(subscriptionItems[index]['serviceName']),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddListpage(subscriptionItem:{});
            }),
          );
          if (newListText != null) {
            setState(() {
              subscriptionItems.add(newListText);
            });
          }
          saveData(subscriptionItems);
        },
      ),
    );
  }
}

void saveData(List<String> list) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setStringList("toDoList", list);
}
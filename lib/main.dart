import 'package:api_task/done.dart';
import 'package:api_task/inprogress.dart';
import './myData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MultiProvider(
      builder: (context, child) => MyApp(),
      providers: [ChangeNotifierProvider(create: (ctx) => MyData())]));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

@override
void initState() {}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyData>(context);
    TextEditingController input_ctl = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            height: 400,
                            padding: EdgeInsets.only(top: 20, bottom: 50),
                            //color: Colors.amber,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Add new note'),
                                Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: input_ctl,
                                    decoration:
                                        InputDecoration(hintText: "Title"),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 300,
                                  child: ElevatedButton(
                                    child: const Text('Add'),
                                    onPressed: () {
                                      myprovider.add(input_ctl.text.toString());
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  child: ElevatedButton(
                                    child: const Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.add))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (newIndex) {
              setState(() {
                currentIndex = newIndex;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.incomplete_circle), label: "Inprogress"),
              BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done")
            ]),
        body: myprovider.allTodoList.isEmpty
            ? FutureBuilder(
                future: myprovider.readAllTasks(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (currentIndex == 0) {
                      return Inprogress();
                    } else {
                      return Done();
                    }
                  } else {
                    return Center(child: Text("An error occured"));
                  }
                },
              )
            : currentIndex == 0
                ? Inprogress()
                : Done());
  }
}

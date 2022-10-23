import 'package:api_task/myData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Done extends StatefulWidget {
  Done({Key? key}) : super(key: key);

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyData>(context, listen: false);
    return ListView.builder(
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Color(0x10838485),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Dismissible(
              key: ValueKey(myprovider.done[i]["ID"].toString()),
              background: Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.red),
                child: Icon(Icons.delete_forever, size: 26),
              ),

              //     child: Icon(Icons.delete_forever, size: 26)),
              child: ListTile(
                title: Text(myprovider.done[i]["Title"].toString(),
                    style: TextStyle(fontSize: 16)),
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, size: 20, color: Colors.blue)),
                subtitle: Wrap(children: [
                  Text(myprovider.done[i]["CreatedDate"],
                      style: TextStyle(fontSize: 16)),
                ]),
              ),
              onDismissed: (Direction) {
                myprovider.removeTask(myprovider.done[i]);
              },
            ),
          );
        },
        itemCount: myprovider.done.length);
  }
}

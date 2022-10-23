import 'package:api_task/myData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Inprogress extends StatefulWidget {
  Inprogress({Key? key}) : super(key: key);

  @override
  State<Inprogress> createState() => _InprogressState();
}

class _InprogressState extends State<Inprogress> {
  TextEditingController edit_input_ctl = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyData>(context);
    return ListView.builder(
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Color(0x10838485),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Dismissible(
              key: ValueKey(myprovider.inprogress[i]["ID"].toString()),
              background: Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.green),
                child: Wrap(children: [
                  Icon(Icons.add),
                  Text(
                    "Done",
                    style: TextStyle(fontSize: 16),
                  )
                ]),
              ),
              secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(color: Colors.red),
                  child: Icon(
                    Icons.delete_forever,
                    size: 26,
                  )),
              child: ListTile(
                title: Text(myprovider.inprogress[i]["Title"].toString(),
                    style: TextStyle(fontSize: 16)),
                trailing: IconButton(
                    onPressed: () {
                      edit_input_ctl.text =
                          myprovider.inprogress[i]["Title"].toString();
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Container(
                                height: 400,
                                padding: EdgeInsets.only(top: 20, bottom: 50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text('Editting'),
                                    Container(
                                      width: 300,
                                      child:
                                          TextField(controller: edit_input_ctl),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 300,
                                      child: ElevatedButton(
                                        child: const Text('Save'),
                                        onPressed: () {
                                          myprovider.edit(
                                              myprovider.inprogress[i],
                                              edit_input_ctl.text.toString());
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
                      setState(() {});
                    },
                    icon: Icon(Icons.edit, size: 20, color: Colors.blue)),
                subtitle: Wrap(children: [
                  Text(myprovider.inprogress[i]["CreatedDate"],
                      style: TextStyle(fontSize: 16)),
                ]),
              ),
              onDismissed: (Direction) {
                if (Direction == DismissDirection.endToStart) {
                  //delete
                  myprovider.removeTask(myprovider.inprogress[i]);
                } else {
                  //done
                  myprovider.changeIsDone(myprovider.inprogress[i]);
                }
              },
            ),
          );
        },
        itemCount: myprovider.inprogress.length);
  }
}

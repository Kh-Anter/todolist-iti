import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MyData with ChangeNotifier {
  static const api_url = "https://api.mohamed-sadek.com";
  List allTodoList = [];
  List inprogress = [];
  List done = [];

  Future<void> readAllTasks() async {
    print("from readAllTasks !");
    allTodoList = [];
    var response = await http.get(Uri.parse(api_url + "/task/get"));
    allTodoList = await json.decode(response.body)["Data"] as List;
    filterTodo();
  }

  filterTodo() {
    inprogress = [];
    done = [];
    allTodoList.forEach((element) {
      if (element["IsDone"]) {
        done.add(element);
      } else {
        inprogress.add(element);
      }
    });
  }

  Future<void> removeTask(task) async {
    var url = Uri.parse(api_url + "/task/delete?id=${task["ID"].toString()}");
    final response = await http.delete(url);
    allTodoList.remove(task);
    inprogress.remove(task);
    done.remove(task);
  }

  Future<void> add(title) async {
    var url = Uri.https("api.mohamed-sadek.com", "Task/POST");
    print("title: ${title}");
    final response = await http.post(url,
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8' // important
        },
        body: jsonEncode(<String, String>{"Title": title.toString()}));
    readAllTasks();
  }

  Future<void> changeIsDone(task) async {
    var url = Uri.parse("https://api.mohamed-sadek.com/Task/PUT");
    final response = await http.put(url,
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8' // important
        },
        body: jsonEncode(<String, Object>{
          "Title": task["Title"].toString(),
          "ID": task["ID"],
          "IsDone": true
        }));
    inprogress.remove(task);
    done.add(task);
  }

  Future<void> edit(task, newTitle) async {
    var url = Uri.parse("https://api.mohamed-sadek.com/Task/PUT");
    final response = await http.put(url,
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8' // important
        },
        body: jsonEncode(<String, Object>{
          "Title": newTitle,
          "ID": task["ID"],
          "IsDone": task["IsDone"]
        }));
    inprogress.forEach((element) {
      if (element["ID"] == task["ID"]) {
        element["Title"] = newTitle;
      }
    });
    done.forEach((element) {
      if (element["ID"] == task["ID"]) {
        element["Title"] = newTitle;
      }
    });
  }
}

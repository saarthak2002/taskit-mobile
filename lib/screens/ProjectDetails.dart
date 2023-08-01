import 'package:flutter/material.dart';
import 'package:taskit_mobile/extentions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectDetails extends StatefulWidget {
  final data;
  ProjectDetails(this.data);
  
  @override
  _ProjectDetailsState createState() => _ProjectDetailsState(data);
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final data;
  _ProjectDetailsState(this.data);
  
  late Future<List<dynamic>> tasks = fetchTasks();
  bool isUpdatingTasks = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(data['title']),
            Text(data['description']),
            Expanded(
              child: taskList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchTasks() async {
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}projects/${data['id']}/tasks"));
    return jsonDecode(result.body);
  }

  markTaskAsComplete(id) async {
    setState(() {
      isUpdatingTasks = true;
    });
    
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    final reponse = await http.post(
      Uri.parse(BASE_API_URL + 'task/${id}/complete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      }),
    );

    setState(() {
      tasks = fetchTasks();
      isUpdatingTasks = false;
    });
  }

  markTaskAsPending(id) async {
    setState(() {
      isUpdatingTasks = true;
    });
    
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    final reponse = await http.post(
      Uri.parse(BASE_API_URL + 'task/${id}/pending'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      }),
    );

    setState(() {
      tasks = fetchTasks();
      isUpdatingTasks = false;
    });
  }

  taskList() {
    return FutureBuilder(
      future: tasks,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isUpdatingTasks) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return const Center(child: Text('No tasks found'));
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return card(snapshot.data[index]);
            },
          );
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  card(task) {
    return Card(
      elevation: 2,
      color: Color.fromARGB(220, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          children: [
            Row (
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: task['task_category_color'].toString().toColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    task['task_category_name'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                task['description'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: task['status'] == 'completed' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(top: 12),
                  child: Text(
                    task['status'].toString().capitalize(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (task['status'] == 'completed') {
                      markTaskAsPending(task['id']);
                    }
                    else {
                      markTaskAsComplete(task['id']);
                    }
                  },
                  iconSize: 35,
                  splashRadius: 30,
                  tooltip: task['status'] == 'pending' ? 'Mark as completed' : 'Mark as pending',
                  color: task['status'] == 'pending' ? Colors.green : Colors.red,
                  icon: task['status'] == 'pending' ? const Icon(Icons.check_circle) : const Icon(Icons.cancel),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
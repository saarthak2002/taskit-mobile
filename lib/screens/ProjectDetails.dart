import 'package:flutter/material.dart';
import 'package:taskit_mobile/extentions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectDetails extends StatefulWidget {
  final data;
  ProjectDetails(this.data);
  
  @override
  _ProjectDetailsState createState() => _ProjectDetailsState(data);
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final data;
  _ProjectDetailsState(this.data);

  List<String> taskCategoryNames = [];
  Map taskCategoryColorMap = Map<String,String>();
  String dropdownTaskCategoryValue = '';

  bool taskTitleError = false;
  bool taskDescriptionError = false;

  @override
  void initState() {
    super.initState();
    taskCategoryNames.add('None');
    taskCategoryColorMap['None'] = '#bab5b5';
    for (var i = 0; i < data['task_categories'].length; i++) {
      taskCategoryNames.add(data['task_categories'][i]['name']);
      taskCategoryColorMap[data['task_categories'][i]['name']] = data['task_categories'][i]['color'];
    }
    print(taskCategoryNames);
    print(taskCategoryColorMap);
    dropdownTaskCategoryValue = taskCategoryNames[0];
  }
  
  late Future<List<dynamic>> tasks = fetchTasks();
  bool isUpdatingTasks = false;

  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
   // default color bab5b5

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return (
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setDropdownState) {
                    return addTaskModal(context, setDropdownState);
                  },
                )
              );
            }
          );
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }

  addTaskModal(context, setDropdownState) {
    return (
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container (
          height: 500,
          child: Padding (
            padding: EdgeInsets.all(20),
            child: Column (
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Task To ${data['title']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: taskTitleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      labelText: 'Title',
                      hintText: 'Title',
                      fillColor: Colors.white70,
                      errorText: taskTitleError ? 'Please enter a title' : null,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: taskDescriptionController,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      labelText: 'Description',
                      hintText: 'Description',
                      fillColor: Colors.white70,
                      errorText: taskDescriptionError ? 'Please enter a description' : null,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 60,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      labelText: 'Task Category',
                      hintText: 'Task Category',
                      fillColor: Colors.white70,
                    ),
                    child: DropdownButtonHideUnderline(
                      child:  DropdownButton(
                        value: dropdownTaskCategoryValue,
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (String? newValue) {
                          setDropdownState(() {
                            dropdownTaskCategoryValue = newValue!;
                          });
                        },
                        items: taskCategoryNames.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      addTask(context, setDropdownState);
                    },
                    child: Text('Add Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<List<dynamic>> fetchTasks() async {
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}projects/${data['id']}/tasks"));
    return jsonDecode(result.body);
  }

  addTask(context, setDropdownState) async {
    String title = taskTitleController.text.trim();
    String description = taskDescriptionController.text.trim();
    if(title == '') {
      setDropdownState(() {
        taskTitleError = true;
      });
      return;
    }
    else {
      setDropdownState(() {
        taskTitleError = false;
      });
    }
    if(description == '') {
      setDropdownState(() {
        taskDescriptionError = true;
      });
      return;
    }
    else {
      setDropdownState(() {
        taskDescriptionError = false;
      });
    }
    Navigator.pop(context);
    setState(() {
      isUpdatingTasks = true;
    });
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    String taskCategoryColor = taskCategoryColorMap[dropdownTaskCategoryValue];
    
    final reponse = await http.post(
      Uri.parse(BASE_API_URL + 'projects/${data['id']}/tasks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "title":title,
        "description": description,
        "task_category_name": dropdownTaskCategoryValue,
        "task_category_color": taskCategoryColor,
        "created_by_user_uid": user!.uid,
      }),
    );

    print(reponse.body);
    taskDescriptionController.clear();
    taskTitleController.clear();
    setState(() {
      tasks = fetchTasks();
      isUpdatingTasks = false;
    });
  }
 
  markTaskAsComplete(id) async {
    setState(() {
      isUpdatingTasks = true;
    });

    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}users/${user!.uid}"));
    var decodedResult = jsonDecode(result.body);
    
    String completed_by = decodedResult['firstname'] + ' ' + decodedResult['lastname'];
    
    final reponse = await http.post(
      Uri.parse(BASE_API_URL + 'task/${id}/complete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "completed_by" : completed_by,
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
      color: Colors.deepPurple[50],
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
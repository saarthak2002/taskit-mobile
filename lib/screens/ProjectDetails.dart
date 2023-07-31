import 'package:flutter/material.dart';

class ProjectDetails extends StatelessWidget {
  ProjectDetails(this.data);
  final data;
  
  @override
  Widget build(BuildContext context) {
    print(data);
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
              child: taskList(data['tasks']),
            ),
          ],
        ),
      ),
    );
  }
}

taskList(tasks) {
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(tasks[index]['title']),
        subtitle: Text(tasks[index]['description']),
      );
    },
  );
}
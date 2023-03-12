import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations_advanced/Screens/TaskList.dart';
import 'package:flutter/material.dart';

class Task_details extends StatefulWidget {
  Map<String, dynamic> map = {};
   Task_details({Key? key, required this.map}) : super(key: key);

  @override
  State<Task_details> createState() => _Task_detailsState();
}

class _Task_detailsState extends State<Task_details> {
  CollectionReference reference = FirebaseFirestore.instance.collection("Tasks");
  bool showloader = false;
  @override
  Widget build(BuildContext context) {
    final NameController = TextEditingController(text: widget.map["name"]);
    final TaskController = TextEditingController(text: widget.map["task"]);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const  task_list()));
        },icon:const  Icon(Icons.arrow_back_outlined,size: 35,),),
        title: const Text("Task details"),
        centerTitle: true,
      ),
      body:  Container(
        margin:const  EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: NameController,
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: TaskController,
            ),
          const   SizedBox(height: 20,),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: () async{
                setState(() {
                  showloader = true;
                });
                var name = NameController.text.toString();
                var task = TaskController.text.toString();
                if(name.isEmpty || task.isEmpty){
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                   shape: RoundedRectangleBorder(),
                     content:  Text("filled both field")));
                 return;
                }
                setState(() {
                  showloader = false;
                });
                await reference.doc(widget.map["id"]).update({
                  "name" : name,
                  "task" : task,
                });

              },child: showloader ?  const CircularProgressIndicator(strokeWidth: 2,): const Text("Update"))),
             const  SizedBox(width: 20,),
              Expanded(child: ElevatedButton(onPressed: (){
                reference.doc(widget.map["id"]).delete().then((value) => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const task_list()))
                });
              },child: const Text("Delete"),))
            ],)
          ],
        ),
      ),
    );
  }
}

import 'package:crud_operations_advanced/Screens/TaskList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add_task extends StatefulWidget {
  const Add_task({Key? key}) : super(key: key);

  @override
  State<Add_task> createState() => _Add_taskState();
}

class _Add_taskState extends State<Add_task> {
  final NameController = TextEditingController();
  final TaskController = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection("Tasks");
  bool showloader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const task_list()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 35,
          ),
        ),
        title: const Text("Add your task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(30)),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  controller: NameController,
                  decoration: const InputDecoration(
                    hintText: "enter your name",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                height: 300,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: TaskController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Write something...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showloader = true;
                  });
                  var name = NameController.text.toString();
                  var task = TaskController.text.toString();
                  Map<String, dynamic> map = {
                    "name": name,
                    "task": task,
                  };
                  if (name.isEmpty || task.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.grey.shade400,
                        duration: const Duration(seconds: 2),
                        dismissDirection: DismissDirection.up,
                        content: const Center(
                            child: Text("Both field are required"))));
                    setState(() {
                      showloader = false;
                    });
                    return;
                  }
                  // String Uid = DateTime.now().millisecondsSinceEpoch.toString();
                  ref.add(map).then((value) => {
                        setState(() {
                          showloader = false;
                        }),
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const task_list()))
                      });
                },
                child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade400,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: showloader
                          ? const Center(child: CircularProgressIndicator(strokeWidth: 3,),)
                          : const Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
              )))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations_advanced/Screens/Task_details.dart';
import 'package:flutter/material.dart';
import 'Add_task.dart';

class task_list extends StatefulWidget {
  const task_list({Key? key}) : super(key: key);

  @override
  State<task_list> createState() => _task_listState();
}

class _task_listState extends State<task_list>  {
  //now to read or display the record from cloud firestore
  CollectionReference _reference =   FirebaseFirestore.instance.collection("Tasks");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _reference.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //check the conditions
                //if there is any error are occured
                if(snapshot.hasError){

                }
                //if the data are arrive
                if(snapshot.hasData){
                 var data = snapshot.data;
                 List<QueryDocumentSnapshot> document = data!.docs;
                 List<Map> items = document.map((e) =>{"name": e["name"], "task" : e["task"], "id" : e.id}).toList();
                  return ListView.builder(
                    itemCount: items.length,
                      itemBuilder: (context,index){
                      var itemList = items[index];
                      final mq = MediaQuery.of(context).size;
                      Map<String,dynamic> map = {
                        "name" : itemList["name"],
                        "task" : itemList["task"],
                        "id" : itemList["id"],
                      };
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Task_details(map: map)));
                        },
                        child: Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          margin: EdgeInsets.symmetric(horizontal:mq.width *0.01,vertical: mq.height*0.004 ),
                          child: Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: mq.width*0.01,vertical: mq.height*0.02),
                              child: ListTile(
                                title: Text(itemList["name"],style:const  TextStyle(fontSize: 22,fontWeight: FontWeight.bold ),),
                                subtitle: Text(itemList["task"],style:const  TextStyle(fontSize: 16,fontWeight: FontWeight.bold ),),
                              ),
                            ),
                          ),
                        ),
                      );

                  });
                }
              //then to load a loader if no data are inserted
                return const Center(child: CircularProgressIndicator(strokeWidth: 4,),);
              },

            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Add_task()));
      },child: const Icon(Icons.add),),
    );
  }
}
/*

* */
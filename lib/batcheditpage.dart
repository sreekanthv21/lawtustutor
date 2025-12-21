

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class batcheditpage extends StatefulWidget {
  final batchid;
  const batcheditpage({required this.batchid,super.key});

  @override
  State<batcheditpage> createState() => _batcheditpageState();
}

class _batcheditpageState extends State<batcheditpage> {

  ValueNotifier notify=ValueNotifier(true);

  var gotinfo=[];

  TextEditingController text=TextEditingController();
  var templist=[];

  void streamlisten(){
    FirebaseFirestore.instance.collection('batches').doc(widget.batchid).snapshots().listen(
      (snapshot){
        gotinfo=snapshot.data()!['subjects'];
        notify.value=!notify.value;
      }
    );
  }

  void initState(){
    super.initState();
    streamlisten();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Batch subjects'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerwidth= constraints.maxWidth>600?700:(constraints.maxWidth)*0.9;
          return Center(
            child: Container(
              width: containerwidth,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text('Add batch subjects',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: containerwidth*0.7,
                        child: TextField(
                          controller: text,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 223, 223, 223),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                            
                          ),
                        ),
                      ),
                      
                      SizedBox(
                        height: 50,
                        width: containerwidth*0.25,
                        child: IconButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            backgroundColor: WidgetStatePropertyAll(Colors.grey)
                          ),
                          
                          onPressed: () {
                            if(text.text!='')
                            {gotinfo.add(text.text);
                            notify.value=!notify.value;
                            text.clear();}

                          },
                          icon: Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      foregroundColor: WidgetStatePropertyAll(Colors.white)
                    ),
                    onPressed: () {
                      try
                      {FirebaseFirestore.instance.collection('batches').doc(widget.batchid).set({'subjects':gotinfo},SetOptions(merge: true));
                      notify.value=!notify.value;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved')));
                      }
                      catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
                      }
                    },
                    child: Text('Save'),
                  ),
                  SizedBox(height: 20,),
                  Text('Subjects',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ValueListenableBuilder(
                    valueListenable: notify,
                    builder: (context, value, child) {
                      return Column(
                        children: List.generate(
                          gotinfo.length,
                          (index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(10),
                                    width: containerwidth*0.7,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 191, 226, 255),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text(gotinfo[index]),
                                  ),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    width: containerwidth*0.1,
                                    child: IconButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 218, 218, 218)),
                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                      ),
                                      color: Colors.red,
                                      icon:Icon(Icons.remove),
                                      onLongPress: () {
                                        gotinfo.removeAt(index);
                                        FirebaseFirestore.instance.collection('batches').doc(widget.batchid).set({'subjects':gotinfo},SetOptions(merge: true));
                                        notify.value=!notify.value;
                                      },
                                      onPressed: () {
                                        
                                      }
                                                          
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        )
                      );
                    }
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
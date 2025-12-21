import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawtustutor/batcheditpage.dart';

class batch extends StatefulWidget {
  const batch({super.key});

  @override
  State<batch> createState() => _batchState();
}

class _batchState extends State<batch> {
  ValueNotifier studentcountprovider=ValueNotifier({});

  void studentcount(batchname,batches,index)async{
    final count = await FirebaseFirestore.instance.collection('students').where('batch',isEqualTo: batches[index]['batch']).count().get();
    print(count.count);
    ((studentcountprovider.value)as Map)[batchname]=(count.count);
    print(studentcountprovider.value);
    studentcountprovider.notifyListeners();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batches'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder:(context,constraints){
          double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
          return Center(
            child: Container(
              width: containerwidth,
              child: Column(
                children: [
                  
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    width: containerwidth*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 211, 211, 211)
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('batches').snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Center(child: Text('Loading...'));
                        }
                        if(snapshot.hasData==false){
                          return Text('Nothing');
                        }
                        final batches=snapshot.data!.docs;
                        return Column(
                          children: List.generate(
                            batches.length,
                            (index){
                              studentcount(batches[index]['batch'],batches, index);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>batcheditpage(batchid: batches[index].id,)));
                                },
                                child: Container(
                                  width: containerwidth*0.7,
                                  padding: EdgeInsets.only(bottom: 10),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 1
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(batches[index]['batch'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                      ValueListenableBuilder(
                                        valueListenable: studentcountprovider,
                                        builder: (context, value, child) {
                                          
                                          if((studentcountprovider.value).length!=batches.length)
                                          {print(studentcountprovider.value);
                                          return Text('Loading...');}
                                          if((studentcountprovider.value).length==batches.length)
                                          {print(studentcountprovider.value);
                                          return Text('Number of students : ${((studentcountprovider.value)as Map)[batches[index]['batch']]}');}
                                          return Text('0');
                                        }
                                      ),
                                      Text('Click to edit',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w200),)
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
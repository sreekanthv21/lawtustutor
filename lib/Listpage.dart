import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawtustutor/Quizmakepage.dart';
import 'package:lawtustutor/items.dart';
import 'package:lawtustutor/options.dart';
import 'package:lawtustutor/provider.dart';
import 'package:lawtustutor/resultfetchpage.dart';
import 'package:lawtustutor/results.dart';
import 'package:provider/provider.dart';

class Listpage extends StatefulWidget {
  const Listpage({super.key});

  @override
  State<Listpage> createState() => _ListpageState();
}

class _ListpageState extends State<Listpage> {


  @override
  void initState(){
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<generator4>().quizlistinfoupdated,
      builder: (context, value, child) {
        if(context.read<generator4>().isLoading){
          print('asf');
          return Center(
            child: SizedBox(height: 30,width: 30,child: CircularProgressIndicator(),),
          );
        }
        print('afsd');
        List quizlist=context.read<generator4>().quizlist;
        print(quizlist);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Quizzes',style: TextStyle(fontWeight: FontWeight.bold),),centerTitle: true,backgroundColor: Colors.white,surfaceTintColor: Colors.white,),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    width: containerwidth,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount:quizlist.length ,
                            itemBuilder: (context, index) {
                              if(quizlist[index].data()['starttime']==null)
                              {return GestureDetector(
        
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder:(context) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        actionsAlignment: MainAxisAlignment.center,
                                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        
                                        
                                        content: 
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 30),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children:[
                                            TextButton(
                                              style: ButtonStyle(
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                backgroundColor: WidgetStatePropertyAll(Colors.black),
                                                minimumSize: WidgetStatePropertyAll(Size(double.infinity,50))
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>quizmake(quizid: quizlist[index].id,batchname: quizlist[index].data()['batch'][0],)));
                                              },
                                              child: Text('Edit',style: TextStyle(color: Colors.white),),
                                            ),
                                            SizedBox(height: 15,),
                                            TextButton(
                                              onPressed:() {},
                                              style: ButtonStyle(
                                                minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                foregroundColor: WidgetStatePropertyAll(Colors.white),
                                                backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 0, 0, 0))
                                              ),
                                              onLongPress: () async{
                                                try
                                                {await FirebaseFirestore.instance.collection('tests').doc(quizlist[index].id).delete();}
                                                catch(e){
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted')));
                                                }
                                                
                                              },
                                              child: Text('Delete'),
                                            ),
                                            
                                                  
                                          ],),
                                        )
                                      ),
                                    );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 217, 218, 219),
                                    borderRadius: BorderRadius.circular(10)
                                
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(quizlist[index].data()['quizname'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                          SizedBox(height: 2,),
                                          Row(
                                          children: List.generate(
                                            quizlist[index].data()['batch'].length,
                                            (index1){
                                              return Text('${quizlist[index].data()['batch'][index1]}, ',style: TextStyle(fontWeight: FontWeight.bold),);
                                            }
                                          )
                                        ),
                                        ],
                                      ),
                                      Text('Click to Continue',style: TextStyle(),)
                                    ],
                                  ),
                                ),
                              );}
                              else{
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:(context) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        actionsAlignment: MainAxisAlignment.center,
                                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 30),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children:[
                                            TextButton(
                                              style: ButtonStyle(
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                backgroundColor: WidgetStatePropertyAll(Colors.black),
                                                minimumSize: WidgetStatePropertyAll(Size(double.infinity,50))
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>quizmake(quizid: quizlist[index].id,batchname: quizlist[index].data()['batch'][0],)));
                                              },
                                              child: Text('Edit',style: TextStyle(color: Colors.white),),
                                            ),
                                            SizedBox(height: 15,),
                                            TextButton(
                                              style: ButtonStyle(
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                backgroundColor: WidgetStatePropertyAll(Colors.black),
                                                minimumSize: WidgetStatePropertyAll(Size(double.infinity,50))
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>schedulepage(quizid: quizlist[index].id,data: quizlist[index].data(),)));
                                              },
                                              child: Text('Options',style: TextStyle(color: Colors.white),),
                                            ),
                                            SizedBox(height: 15,),
                                            TextButton(
                                              style: ButtonStyle(
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                backgroundColor: WidgetStatePropertyAll(Colors.black),
                                                minimumSize: WidgetStatePropertyAll(Size(double.infinity,50))
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider.value(value: generator(quizid:quizlist[index].id ),child: resultpage(quizid: quizlist[index].id)) ,));
                                              },
                                              child: Text('Results',style: TextStyle(color: Colors.white,),)
                                            )
                                          ],),
                                        )
                                      ),
                                    );
                                    
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 217, 218, 219),
                                      borderRadius: BorderRadius.circular(10)
                                  
                                    ),
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(quizlist[index].data()['quizname'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                        SizedBox(height: 2,),
                                        Row(
                                          children: List.generate(
                                            quizlist[index].data()['batch'].length,
                                            (index1){
                                              return Text('${quizlist[index].data()['batch'][index1]}, ',style: TextStyle(fontWeight: FontWeight.bold),);
                                            }
                                          )
                                        ),
                                        SizedBox(height: 6,),
                                        Text(converttodate((quizlist[index].data()['starttime']).toDate())),
                                        SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              timecontainer(index,converttotime(quizlist[index].data()['starttime'].toDate())),
                                              Expanded(child: Container(margin: EdgeInsets.symmetric(horizontal: 50),height: 1,color: Colors.black,)),
                                              timecontainer(index, converttotime(quizlist[index].data()['endtime'].toDate()))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }

  
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lawtustutor/items.dart';
import 'package:intl/intl.dart';


class schedulepage extends StatefulWidget {
  final quizid;
  final data;
  const schedulepage({required this.data,required this.quizid,super.key});

  @override
  State<schedulepage> createState() => _schedulepageState();
}

class _schedulepageState extends State<schedulepage> {

  TextEditingController showquiz=TextEditingController();
  TextEditingController showres=TextEditingController();


  Container timecontainerschedule(data, isnew) {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isnew==true?const Color.fromARGB(255, 136, 255, 0):Colors.amber,
          borderRadius: BorderRadius.circular(5)

        ),
        child: Text(data,style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),));
    }
//schedule
  Future<void> scheduleFunction(starttime,endtime) async {

  final url = Uri.parse('https://lawtusbackend.onrender.com/scheduleWritetest');

  final payload = {
    "data1": {'time':starttime,'status':'available','quizid':widget.quizid},
    "data2": {'time':endtime,'status':'over','quizid':widget.quizid},
    'quizid': widget.quizid
  };

  try {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator(),),);
      },
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (!mounted) return;
    Navigator.pop(context);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scheduled')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
    }
  } catch (e) {
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
  }
}
// deleteschedule
Future<void> scheduledeleteFunction(task1id,task2id) async {
  final url = Uri.parse('https://lawtusbackend.onrender.com/deletecloudtask');

  final payload = {
    'task1id':task1id,
    'task2id':task2id,
    'quizid': widget.quizid
  };

  try {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator(),),);
      },
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (!mounted) return;
    Navigator.pop(context);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Schedule removed')));
      print("Response: ${response.body}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
    }
  } catch (e) {
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
  }
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tests').doc(widget.quizid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if(snapshot.hasError){
          return Text('error');
        }
        
        Map? scheduledata=snapshot.data!.data();
        bool isScheduled=false;
        print(scheduledata);
        if(scheduledata!['scheduledstarttime']!=null){
          isScheduled=true;
        }
        
        print(isScheduled);
        print(scheduledata!['scheduledstarttime']);
        
        

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(16),
        
                    padding: EdgeInsets.all(16),
                    width: containerwidth,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:  const Color.fromARGB(255, 216, 216, 216),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                if (!isScheduled)
                                Text('Quiz is not yet scheduled'),
                      
                                if(isScheduled)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    timecontainerschedule(converttotime(scheduledata['scheduledstarttime'].toDate()),true),
                                    Container(width: 100,height: 1,color: Colors.black,),
                                    timecontainerschedule(converttotime(scheduledata['scheduledendtime'].toDate()),true)
                                  ],
                                ),
                                if(isScheduled)
                                SizedBox(height: 20,),
                                if(isScheduled)
                                Text('This quiz is scheduled',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                if(isScheduled)
                                SizedBox(height: 30,),
                                if(isScheduled)
                                TextButton(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                    minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                                    backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 234, 234, 234))
                                  ),
                                  onPressed: () async{
                                    scheduledeleteFunction(scheduledata['task1id'], scheduledata['task2id']);
                                  },
                                  child: Text('Remove the schedule',style: TextStyle(color: Colors.red),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:  const Color.fromARGB(255, 216, 216, 216),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    timecontainerschedule(converttotime(scheduledata['starttime'].toDate()),false),
                                    Container(width: 100,height: 1,color: Colors.black,),
                                    timecontainerschedule(converttotime(scheduledata['endtime'].toDate()),false)
                                  ],
                                ),
                                SizedBox(height: 20,),
                                
                                TextButton(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                                    backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 0, 0, 0)),
                                    minimumSize: WidgetStatePropertyAll(Size(double.infinity,50))
                                  ),
                                  onPressed: () async{
                                    if(isScheduled){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Already scheduled')));
                                      return;
                                    }
                                    else{
                                      try{
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: CircularProgressIndicator()
                                              ),
                                            );
                                          },
                                        );
                                        final res = await http.get(Uri.parse('https://lawtusbackend.onrender.com/functogetlivetime'),);
                                        if(DateTime.parse(jsonDecode(res.body)['time']).isAfter(scheduledata['starttime'].toDate())){
                                          if(context.mounted)
                                          {Navigator.pop(context);}
                                          if(context.mounted)
                                          {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scheduling time is already over')));}
                                          return;
                                        }
                                        else{
                                          if(context.mounted){
                                            Navigator.pop(context);
                                          }
                                        }
                                        }catch(e){
                                          if(context.mounted)
                                          {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network error')));}
                                          return;
                                        }
                                    }
                                    
                                    scheduleFunction(scheduledata['starttime'].toDate().toIso8601String(), scheduledata['endtime'].toDate().toIso8601String());
                                  },
                                  child: Text('Schedule this quiz'),
                                ),
                               
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: 600,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 216, 216, 216),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Show this quiz on app'),
                                    SizedBox(
                                      width: 100,
                                      child: DropdownMenu(
                                        controller: showquiz,
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: true,
                                            label: 'Yes'
                                            
                                          ),
                                          DropdownMenuEntry(
                                            value: false,
                                            label: 'No'
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Show quiz result on app'),
                                    SizedBox(
                                      width: 100,
                                      child: DropdownMenu(
                                        controller: showres,
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: true,
                                            label: 'Yes'
                                            
                                          ),
                                          DropdownMenuEntry(
                                            value: false,
                                            label: 'No'
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                TextButton(
                                  style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                                  backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 0, 0, 0))
                                ),
                                  onPressed: () async{
                                    if(showquiz.text=='' || showres.text==''){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dude, first fill the field')));
                                    }
                                    else if(DateTime.now().isBefore( widget.data['endtime'].toDate()) && showres.text=='Yes'){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dude, first let the quiz finish ')));
                                    }
                                    else
                                    {await FirebaseFirestore.instance.collection('tests').doc(widget.quizid).update({'showresult':showres.text=='Yes'?true:false,'show':showquiz.text=='Yes'?true:false});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successful')));
                                    }
                                  },
                                  child: Text('Update'),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          TextButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                              minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                              backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 234, 234, 234))
                            ),
                            onPressed: () async{
                              try
                              {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: SizedBox(width:30,height:30 ,child:CircularProgressIndicator()),
                                    );
                                  },
                                );
                                await FirebaseFirestore.instance.collection('tests').doc(widget.quizid).delete();
                                if(context.mounted){
                                  Navigator.pop(context);
                                }
                                }
                              catch(e){
                                if(context.mounted){
                                  Navigator.pop(context);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
                              }finally{
                                if(context.mounted){
                                  Navigator.pop(context);
                                }
                               
                              }
                              
                            },
                            child: Text('Delete',style: TextStyle(color: Colors.red),),
                          ),
                              
                        ],
                      ),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lawtustutor/Quizmakepage.dart';
import 'package:lawtustutor/items.dart';
import 'package:lawtustutor/provider.dart';
import 'package:provider/provider.dart';

class makequizfirstpage extends StatefulWidget {
  const makequizfirstpage({super.key});

  @override
  State<makequizfirstpage> createState() => _makequizfirstpageState();
}

class _makequizfirstpageState extends State<makequizfirstpage> {
  TextEditingController quiznamecont = TextEditingController();
  TextEditingController coursecont = TextEditingController();
  TextEditingController negcont=TextEditingController();
  bool ispressed=false;
  var batchdata=[];
  var batchinfo=[];
  ValueNotifier batchdataupdated=ValueNotifier(true);

  bool checksubjects(){
    bool check=true;
    var refinedlist=[];

    for(int i=0;i<batchinfo.length;i++){
      if(batchdata.contains(batchinfo[i].data()['batch'])){
        refinedlist.add(batchinfo[i]);
      }
    }

    for(int i=0;i<(batchdata.length-1);i++){
      
      check=refinedlist[i].data()['subjects'].toSet().containsAll(refinedlist[i+1].data()['subjects']);
      
      if(!check){
        return check;
      }
    }
    return check;
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create quiz'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context,constraints){
          final maxwidth=constraints.maxWidth;
          return Center(
            child: SafeArea(
              child: Container(
                width: maxwidth>600?1000:maxwidth*0.9,
                child: Column(
                  children: [
                    SizedBox(width: maxwidth,child: field('Quizname', quiznamecont)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ValueListenableBuilder(
                        valueListenable: context.read<generator1>().batchinfoupdated,
                        builder: (context, value, child) {
                          batchinfo=context.read<generator1>().batchinfo;
                          final batchtobeputindropdown=batchinfo.map((e) {
                            return DropdownMenuEntry(value: e['batch'], label: e['batch']);
                          },).toList();

                          
                          return DropdownMenu(
                            controller: coursecont,
                            width: double.infinity,
                            hintText: 'Select the batch',
                            onSelected: (value) {
                              if(batchdata.contains(value)==false){
                                batchdata.add(value);
                                batchdataupdated.value=!batchdataupdated.value;
                                
                              }
                            },
                            dropdownMenuEntries: batchtobeputindropdown
                          );
                        }
                      ),
                      
                    ),
                    ValueListenableBuilder(
                      valueListenable: batchdataupdated,
                      builder: (context, value, child) {
                        return Row(
                          children: List.generate(
                            batchdata.length,
                            (index){
                              return Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 202, 231, 255),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(batchdata[index]),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        batchdata.removeAt(index);
                                        batchdataupdated.value=!batchdataupdated.value;
                                      },
                                      icon: Icon(Icons.delete),
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                        );
                      }
                    ),
                    SizedBox(height: 10,),
                    SizedBox(width: 300,child: field('neg mark', negcont)),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(Size(200,40)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          backgroundColor: WidgetStatePropertyAll(Colors.black)
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Container(
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Quiz name : ${quiznamecont.text}'),
                                      Text('Batch : ${coursecont.text}'),
                                      Text('Negative mark :${negcont.text.trim()}')
                                    ],
                                  ),
                                ),
                                actionsPadding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                actions: [
                                  TextButton(
                                    style: ButtonStyle(
                                    minimumSize: WidgetStatePropertyAll(Size(double.infinity,40)),
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                    backgroundColor: WidgetStatePropertyAll(Colors.black)
                                  ),
                                    onPressed: ispressed?null:()async {
                                      if(ispressed)return;
                                       
                                      {if(quiznamecont.text==''|| coursecont.text==''|| negcont.text==''){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fields are null')));
                                        return;
                                      }
                                      else if(double.tryParse(negcont.text.trim())==null){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Negative mark only accepts number')));
                                      }
                                      else if(!checksubjects()){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't select batches having different subjects")));
                                      }
                                      else
                                      { ispressed=true;
                                        setState(() {
                                        
                                      });
                                      try
                                        {final data=await FirebaseFirestore.instance.collection('tests').add({'quizname':quiznamecont.text,'batch':batchdata,'creationtime':FieldValue.serverTimestamp(),'quiztype':'MCQ','negmark':double.parse(negcont.text.trim())});
                                        
                                        if(context.mounted)
                                        {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>quizmake(quizid:data.id,batchname:coursecont.text  ,)));}}
                                        
                                        catch(e){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
                                        }finally{
                                          if(mounted)
                                          {setState(() {
                                            ispressed=false;
                                          });}
                                        }
                                      }}
                                      
                                      
                                    },
                                    child: Text('Create Quiz',style: TextStyle(color: Colors.white),),
                                  )
                                ],
                              );
                            },
                          );
                          
                        },
                        child: Text('Prepare questions',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),),
                        
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
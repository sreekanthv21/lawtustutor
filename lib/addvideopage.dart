import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lawtustutor/items.dart';
import 'package:lawtustutor/provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class addvideopage extends StatefulWidget {

  final index;

  const addvideopage({required this.index,super.key});

  @override
  State<addvideopage> createState() => _addvideopageState();
}

class _addvideopageState extends State<addvideopage> {

  TextEditingController namecont = TextEditingController();
  TextEditingController subcont = TextEditingController();
  TextEditingController pathdircont = TextEditingController();
  TextEditingController pathid = TextEditingController();
  TextEditingController thumbnailcont = TextEditingController();
  TextEditingController facultycont = TextEditingController();
  TextEditingController durcont = TextEditingController();
  TextEditingController batchcont = TextEditingController();
  List batchdata=[];
  var uuid=Uuid();
  ValueNotifier batchdataupdated = ValueNotifier(true);
  ValueNotifier showinnew=ValueNotifier(false);
  void adder(videos)async{
    try{
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CircularProgressIndicator();
        },
      );
      await FirebaseFirestore.instance.collection('videos').doc('lawtusvids').set({
        widget.index==0?((videos.length)+1).toString():(widget.index).toString():{
          "name":namecont.text,
          "pathdir":pathdircont.text,
          "pathid":pathid.text,
          "img":thumbnailcont.text,
          "duration":int.parse(durcont.text),
          "batch":batchdata,"faculty":facultycont.text,
          "subject":subcont.text,
          "showinnew":showinnew.value,
          "uuid":uuid.v4()
          }
      },SetOptions(merge: true));
      Navigator.pop(context);
    }catch(e){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Couldn't process"),
          );
        },
      );
    }finally{
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Successfully added'),
          );
        },
      );
    }
  }

  void refiner(Map videos,List studentinfo)async{
    videos.remove(widget.index);
    List keys=videos.keys.toList();
    Map<String,dynamic> newvideos={};

    for(int i=0;i<keys.length;i++){
      newvideos[(i+1).toString()]=videos[keys[i]];
      
    }

   
    

    try{
      print('yo');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator()));
        },
      );
      await FirebaseFirestore.instance.collection('videos').doc('lawtusvids').set(newvideos);
      Navigator.pop(context);
    }catch(e){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Couldn't process"),
          );
        },
      );
    }finally{
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Successfully removed'),
          );
        },
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: generator3(),
      child: ChangeNotifierProvider.value(
        value: generator2(),
        child: ChangeNotifierProvider.value(
          value: generator1(),
          child: StreamBuilder(
            stream: InternetConnection().onStatusChange,
            builder: (context, snapshot) {
              if(snapshot.data==InternetStatus.disconnected){
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 5,),
                        Text('Checking for internet...',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                );
              }
              return ValueListenableBuilder(
                valueListenable: context.read<generator3>().studentsinfoupdated,
                builder: (context, value, child) {
                  return ValueListenableBuilder(
                    valueListenable: context.read<generator2>().videoinfoupdated,
                    builder: (context, value, child) {
                      final videoinfo=context.read<generator2>().videoinfo;
                      
                      if(videoinfo==null || context.read<generator3>().isLoading ){
                        return Scaffold(
                          body: Center(
                            child: Container(
                              child: Text('Loading...'),
                            ),
                          ),
                        );
                      }
                      final studentsinfo=context.read<generator3>().studentsinfo;
                      
                      if(widget.index!=0){
                        namecont.text=videoinfo[widget.index]['name'];
                        subcont.text=videoinfo[widget.index]['subject'];
                        pathdircont.text=videoinfo[widget.index]['pathdir'];
                        pathid.text=videoinfo[widget.index]['pathid'];
                        facultycont.text=videoinfo[widget.index]['faculty'];
                        durcont.text=(videoinfo[widget.index]['duration']).toString();
                        thumbnailcont.text=videoinfo[widget.index]['img'];
                        batchdata=videoinfo[widget.index]['batch'];
                        showinnew.value=videoinfo[widget.index]['showinnew'];
                        batchdataupdated.value=!batchdataupdated.value;
                      }
                      
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(widget.index==0?'Add Video':'Edit'),
                          centerTitle: true,
                        ),
                        body: LayoutBuilder(
                          builder: (context, constraints) {
                            double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
                            return Center(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: containerwidth,
                                  child: Column(
                                    children: [
                                      field('Name', namecont),
                                      field('Subject', subcont),
                                      field('Path directory',pathdircont ),
                                      field('Path Id', pathid),
                                      field('Thumbnail', thumbnailcont),
                                      field('Faculty', facultycont),
                                      field('Duration', durcont),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: context.read<generator1>().batchinfoupdated,
                                              builder: (context, value, child) {
                                                final batchinfo = context.read<generator1>().batchinfo;
                                                return DropdownMenu(
                                                  controller: batchcont,
                                                  dropdownMenuEntries: batchinfo.map((each){
                                                    return DropdownMenuEntry(value: each.data()['batch'], label: each.data()['batch']);
                                                  }).toList()
                                                );
                                              }
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if(batchdata.contains(batchcont.text)==false&& batchcont.text!='')
                                                {batchdata.add(batchcont.text);
                                                batchdataupdated.value=!batchdataupdated.value;}
                                              },
                                              icon: Icon(Icons.add),
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStatePropertyAll(Colors.black),
                                                iconColor: WidgetStatePropertyAll(Colors.white),
                                                fixedSize: WidgetStatePropertyAll(Size(100,50)),
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                                              ),
                                            )
                                          ],
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
                                                  padding: EdgeInsets.all(8),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(255, 221, 240, 255),
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(batchdata[index],style: TextStyle(fontWeight: FontWeight.bold),),
                                                      ),
                                                      IconButton(
                                                        padding: EdgeInsets.all(0),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ValueListenableBuilder(
                                          valueListenable: showinnew,
                                          builder: (context, value, child) {
                                            return ElevatedButton(
                                              style: ButtonStyle(
                                                minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                                                backgroundColor: WidgetStatePropertyAll(showinnew.value==true?Colors.green:Colors.red),
                                                foregroundColor: WidgetStatePropertyAll(Colors.white),
                                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                              ),
                                              onPressed: () {
                                                showinnew.value=!showinnew.value;
                                              },
                                              child: Text('Show in latest'),
                                            );
                                          }
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                                            backgroundColor: WidgetStatePropertyAll(Colors.black),
                                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                          ),
                                          onPressed: () {
                                            adder(videoinfo);
                                          },
                                          child: Text('Save'),
                                        ),
                                      ),
                                      if(widget.index!=0)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                                            backgroundColor: WidgetStatePropertyAll(Colors.black),
                                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                          ),
                                          onPressed: () {
                                            refiner(videoinfo,studentsinfo);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ),
                                                      
                                      
                                                
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}
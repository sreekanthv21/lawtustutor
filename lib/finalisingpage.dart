import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart"as dtp;
import 'package:lawtustutor/items.dart';



class Finalisingpage extends StatefulWidget {
  final quizid;
  const Finalisingpage({required this.quizid,super.key});

  @override
  State<Finalisingpage> createState() => _FinalisingpageState();
}

class _FinalisingpageState extends State<Finalisingpage> {
  var selectedstartdate;
  var selectedstartdateinstring;
  var selectedenddate;
  var selectedenddateinstring;
  var duration;

  void durationpicker()async{
    final result =await showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(textButtonTheme: TextButtonThemeData(style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.black)
          ))),
          child: DurationPickerDialog(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
            ),
            initialTime: duration==null?Duration(minutes: 30):duration,
          ),
        );
      },
    );
    setState(() {
      duration=result;
    });
  }

  TextEditingController datecont=TextEditingController();
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Decide the timing'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double containerwidth=constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
            return Center(
              child: Container(
                margin: EdgeInsets.all(8),
                width: containerwidth,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start Time : ',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: containerwidth/2,
                          child: TextField(
                            controller: datecont,
                            onTap: () {
                            dtp.DatePicker.showDateTimePicker(context,
                            minTime: DateTime.now(),
                            theme: dtp.DatePickerTheme(
                              backgroundColor: Colors.white,
                              cancelStyle: TextStyle(color: const Color.fromARGB(255, 105, 105, 105), fontWeight: FontWeight.bold),
                              itemStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              doneStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            currentTime: selectedstartdate==null?DateTime.now():selectedstartdate,
                            onConfirm: (time) {
                              selectedstartdate=time;
                              selectedstartdateinstring=converttodateandtime(time);
                              setState(() {
                                
                              });
                            },
                            );
                            },
                            readOnly: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              
                              hintText:  selectedstartdateinstring==null?'Click to pick':selectedstartdateinstring,
                              fillColor: const Color.fromARGB(255, 214, 214, 214),
                              filled: true,
                              border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(20)),
                              
                            ),
                            
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('End Time : ',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: containerwidth/2,
                          child: TextField(
                            controller: datecont,
                            onTap: () {
                            dtp.DatePicker.showDateTimePicker(context,
                            minTime: DateTime.now(),
                            theme: dtp.DatePickerTheme(
                              backgroundColor: Colors.white,
                              cancelStyle: TextStyle(color: const Color.fromARGB(255, 105, 105, 105), fontWeight: FontWeight.bold),
                              itemStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              doneStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            currentTime: selectedenddate==null?DateTime.now():selectedenddate,
                            onConfirm: (time) {
                              selectedenddate=time;
                              selectedenddateinstring=converttodateandtime(time);
                              setState(() {
                                
                              });
                            },
                            );
                            },
                            readOnly: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              
                              hintText:  selectedstartdateinstring==null?'Click to pick':selectedenddateinstring,
                              fillColor: const Color.fromARGB(255, 214, 214, 214),
                              filled: true,
                              border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(20)),
                              
                            ),
                            
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duration : ',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: containerwidth/2,
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              durationpicker();
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromARGB(255, 205, 205, 205),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              hintText: duration==null?'Pick':'${duration.inMinutes} minutes'
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                    TextButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        
                        fixedSize: WidgetStatePropertyAll(Size(300,40)),
                        backgroundColor: WidgetStatePropertyAll(Colors.black)
                      ),
                      onPressed: ()async {
                        if(selectedenddate==null||selectedstartdate==null||duration==null||selectedenddate.difference(selectedstartdate)<duration){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
                        }
                        else
                        {try
                        {await FirebaseFirestore.instance.collection('tests').doc(widget.quizid).update({'starttime':Timestamp.fromDate(selectedstartdate),'endtime':Timestamp.fromDate(selectedenddate),'duration':duration.inMinutes});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved')));
                        }catch(e){
                          print(e);
                        }}
                      },
                      child: Text('Save',style: TextStyle(color: Colors.white),),
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
}
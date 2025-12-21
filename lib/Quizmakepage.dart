import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lawtustutor/finalisingpage.dart';
import 'package:lawtustutor/items.dart';

class quizmake extends StatefulWidget {
  final quizid;
  final batchname;
  const quizmake({required this.batchname,required this.quizid,super.key});

  @override
  State<quizmake> createState() => _quizmakeState();
}

class _quizmakeState extends State<quizmake> {
  var convlist=[];
  String? selectedquestion='1';

  StreamSubscription? sub1;
  StreamSubscription? sub2;
  
  void ordering(){
    convlist.clear();
    
    for (int i=0;i<questions.length;i++){
      convlist.add(int.parse(questions.keys.toList()[i]));
      
    }
    convlist.sort();
  }

  Map questions={};
  List batchsubjects=[];

  List <DropdownMenuEntry>batchsubjectsdropdown=[];

 
  void getinfo1(){
    sub1=FirebaseFirestore.instance.collection('tests').doc(widget.quizid).snapshots().listen((snapshot){
    // Check if document exists
    if (!snapshot.exists) {
      print('Document does not exist');
      setState(() {
        questions = {}; // Clear or init as needed
        // You can also set a flag here like `noDoc = true`
      });
      return;
    }

    final data = snapshot.data();

    // Extra safety: Check if 'questions' exists
    if (data == null || data['questions'] == null) {
      print('Questions field missing');
      setState(() {
        questions = {}; // Or show fallback UI
      });
      return;
    }

    print('Questions loaded');
    setState(() {
      questions = Map<String, dynamic>.from(data['questions']);
      ordering(); // your own function
    });
  });
  }

  void getinfo2(){
    sub2=FirebaseFirestore.instance.collection('batches').where('batch',isEqualTo: widget.batchname).snapshots().listen((snapshot){
      if (!snapshot.docs[0].exists) {
      print('Document does not exist');
      setState(() {
        batchsubjects=[]; // Clear or init as needed
        // You can also set a flag here like `noDoc = true`
      });
      return;
    }

    final data = snapshot.docs[0].data();

    // Extra safety: Check if 'questions' exists
    if (data == null || data['subjects'] == null) {
      print('Subjects field missing');
      setState(() {
        batchsubjects=[]; // Or show fallback UI
      });
      return;
    }

    print('Questions loaded');
    setState(() {
      batchsubjects = data['subjects'];
      // your own function
      batchsubjectsdropdown=batchsubjects.map((each){
        return DropdownMenuEntry(
          value: each,
          label: each
        );
      }).toList();
    });

    });
  }

  @override
  void initState(){
    super.initState();
    getinfo1();
    getinfo2();
  }

  @override
  void dispose(){
    questcont.dispose();
    opt1cont.dispose();
    opt2cont.dispose();
    opt3cont.dispose();
    opt4cont.dispose();
    optccont.dispose();
    markcont.dispose();
    numcont.dispose();
    sub1!.cancel();
    sub2!.cancel();
    super.dispose();
  }

  TextEditingController questcont =TextEditingController();
  TextEditingController opt1cont =TextEditingController();
  TextEditingController opt2cont =TextEditingController();
  TextEditingController opt3cont =TextEditingController();
  TextEditingController opt4cont =TextEditingController();
  TextEditingController optccont =TextEditingController();
  TextEditingController markcont =TextEditingController();
  TextEditingController numcont =TextEditingController();
  TextEditingController qnsub = TextEditingController();
  ValueNotifier correctoption=ValueNotifier(null);
 

  @override
  Widget build(BuildContext context) {
    if(questions=={})
    return Scaffold();
    else
    {return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Prepare'),centerTitle: true,backgroundColor: Colors.white,surfaceTintColor: Colors.white,
        actions: [
        TextButton(
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(100,40)),
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
          ),
          onPressed: ()async {
            try{
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => Center(child: SizedBox(width:30,height: 30,child: CircularProgressIndicator())),
              );
              await FirebaseFirestore.instance.collection('tests').doc(widget.quizid).update({'questions': questions});

              if(context.mounted){
                Navigator.pop(context);
              }
              if(context.mounted)
              {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved')));}
            }catch(e){
              if(context.mounted)
              {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));}
            }
          },
          child: Text('Save',style: TextStyle(color: Colors.white),),
        ),
      ],actionsPadding: EdgeInsets.symmetric(horizontal: 15),),
      body: SafeArea(
        child: LayoutBuilder(

          builder:(context, constraints){ 
            if(questions.isNotEmpty && selectedquestion!=null)
            {questcont.text=questions[selectedquestion]['question'];
            opt1cont.text=questions[selectedquestion]['1'];
            opt2cont.text=questions[selectedquestion]['2'];
            opt3cont.text=questions[selectedquestion]['3'];
            opt4cont.text=questions[selectedquestion]['4'];
            correctoption.value=questions[selectedquestion]['answer'];
            markcont.text=questions[selectedquestion]['mark'].toString();
            numcont.text=selectedquestion!;
            qnsub.text=questions[selectedquestion]['subject'];
            
            
            }

            final maxwidth=constraints.maxWidth;
            double containerwidth=maxwidth>1000?1000:maxwidth*0.95;
            return Center(
              child: Container(
                height: 1000,
                width: containerwidth,
                child: SingleChildScrollView(
                  child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: containerwidth*0.2,child: field("No", numcont)),
                        SizedBox(width: containerwidth*0.8,child: field('Question',questcont)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Text('A'),
                        SizedBox(width: 10,),
                        Expanded(child: field('Option 1',opt1cont)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Text('B'),
                        SizedBox(width: 10,),
                        Expanded(child: field('Option 2',opt2cont)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Text('C'),
                        SizedBox(width: 10,),
                        Expanded(child: field('Option 3',opt3cont)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8,),
                        Text('D'),
                        SizedBox(width: 10,),
                        Expanded(child: field('Option 4',opt4cont)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: correctoption,
                          builder: (context, value, child) {
                            return DropdownMenu(
                              controller: optccont,
                              initialSelection: correctoption.value,
                              onSelected: (value) {
                                correctoption.value=value;
                              },
                              hintText: 'Correct answer',
                              width: (containerwidth/3)-10,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: 1, label: 'A'),
                                DropdownMenuEntry(value: 2, label: 'B'),
                                DropdownMenuEntry(value: 3, label: 'C'),
                                DropdownMenuEntry(value: 4, label: 'D'),
                              ],
                            );
                          }
                        ),
                        
                        SizedBox(width:(containerwidth/3)-10,child: field( 'Mark', markcont)),
                        SizedBox(
                          width: (containerwidth/3)-10,
                          child: DropdownMenu(
                            hintText: 'Subject',
                            width: (containerwidth/3)-10,
                            controller: qnsub,
                            dropdownMenuEntries:batchsubjectsdropdown 
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8,vertical: 5)),
                            fixedSize: WidgetStatePropertyAll(Size((containerwidth/3)-10,40)),
                            backgroundColor: WidgetStatePropertyAll(Colors.black),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                          ),
                          onPressed: () {
                            
                            if(questcont.text!=''&& opt1cont.text!=''&& opt2cont.text!=''&& opt3cont.text!=''&& opt4cont.text!=''&& numcont.text!=''&& markcont.text!='' && correctoption.value!=null&& qnsub.text!='')
                            {
                              
                              if(num.tryParse(numcont.text)!=null && num.tryParse(markcont.text)!=null)
                              {questions[numcont.text]={'question':questcont.text,'1':opt1cont.text,'2':opt2cont.text,'3':opt3cont.text,'4':opt4cont.text,'mark':int.parse(markcont.text),'answer':correctoption.value,'subject':qnsub.text};
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added')));
                              setState(() {
                                selectedquestion=null;
                                questcont.clear();
                                opt1cont.clear();
                                opt2cont.clear();
                                opt3cont.clear();
                                opt4cont.clear();
                                correctoption.value=null;
                                optccont.clear();
                                markcont.clear();
                                numcont.clear();
                              
                              });}
                              else if(num.tryParse(markcont.text)==null){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter valid marks')));
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter valid question number')));   
                              }
                            }
                            else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some fields are empty')));       
                            }
                          },
                          child: Text("Add/Update",style: TextStyle(color: const Color.fromARGB(255, 210, 210, 210)),),
                        ),
                        
                        TextButton(
                          onLongPress: () {
                            try{
                              questions.remove(selectedquestion);
                              ordering();
                              setState(() {
                                selectedquestion=convlist[0].toString();
                              });
                            }catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted')));        
                            }
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8,vertical: 5)),
                            fixedSize: WidgetStatePropertyAll(Size((containerwidth/3)-10,40)),
                            backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 234, 234, 234)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                          ),
                          onPressed: () {
                            
                          },
                          child: Text('Delete',style: TextStyle(color: const Color.fromARGB(255, 243, 33, 33))),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8,vertical: 5)),
                            fixedSize: WidgetStatePropertyAll(Size((containerwidth/3)-10,40)),
                            backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 238, 238, 238)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                          ),
                          onPressed: () {
                            Map reorderedmap={};
                            ordering();
                            for(int i=0;i<convlist.length;i++){
                              var value= questions[convlist[i].toString()];
                              reorderedmap[(i+1).toString()]=value;
                            }
                            questions=Map.from(reorderedmap);
                            setState(() {
                              ordering();
                              selectedquestion=convlist[0].toString();
                            });
                            
                          },
                          child: Text('Reorder',style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    
                    
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: kIsWeb?8:5),
                      itemCount: questions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ordering();
                        return GestureDetector(
                          onTap: () {
                            selectedquestion=convlist[index].toString();
                            setState(() {
                              
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,style:convlist[index].toString()==selectedquestion?BorderStyle.solid: BorderStyle.none),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 189, 189, 189)
                            ),
                            width: 50,
                            height: 50,
                            child: Text(convlist[index].toString()),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        fixedSize: WidgetStatePropertyAll(Size(600,50)),
                        backgroundColor: WidgetStatePropertyAll(Colors.black)
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Finalisingpage(quizid: widget.quizid)));
                      },
                      child: Text('Next',style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(height: 30,)
                  ],
                  ),
                ),
              ),
            );}
        ),
      ),
    );
  }}

}
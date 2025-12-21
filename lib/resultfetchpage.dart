import 'package:flutter/material.dart';
import 'package:lawtustutor/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;


import 'package:lawtustutor/platform-specific-download/switcher.dart';

class resultfetchpage extends StatefulWidget {
  final quizdata;
  const resultfetchpage({required this.quizdata,super.key});

  @override
  State<resultfetchpage> createState() => _resultfetchpageState();
}

class _resultfetchpageState extends State<resultfetchpage> {

  int selectediqm=1;
  int selectedswm=1;

  List marks=[];
  List studentinfo=[];


  Map totalmarks(){
    Map correctanswers=(widget.quizdata.data()['questions']);
    Map totalmarkmap={};
    
    for (int i=0;i<marks.length;i++){
      
      Map answers=(marks[i].data() as Map)[widget.quizdata.id];
      double total=0;
      for (int i=0;i<correctanswers.length;i++){
        if(correctanswers[(i+1).toString()]['answer']==answers[(i+1).toString()]){
          
          total+=correctanswers[(i+1).toString()]['mark'];
        }
        else if(answers[(i+1).toString()]==null){
          
        }
        else{
          total-=(widget.quizdata.data()['negmark']);
        }
        
      }
      totalmarkmap[marks[i].id]=total;
      
      
    }
    return totalmarkmap;
  }

  Map individualmarking(){
    Map individualmarking={};
    Map correctanswers=(widget.quizdata.data()['questions']);
    for (int i=0;i<marks.length;i++){
      
      List indqnans=[];
      for(int j=0;j<correctanswers.length;j++){
        
        if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==null){
          indqnans.add('Nil');
        }
        else{
          indqnans.add(marks[i].data()[widget.quizdata.id][(j+1).toString()]);
        }
      }
      individualmarking[marks[i].id]=indqnans;
    }
    return individualmarking;
  }

  Map subwisemarking(){
    Map correctanswers=(widget.quizdata.data()['questions']);
   
    Map subwisewarking={};
    for (int i=0;i<marks.length;i++){
      double GKmarks=0;
      double LRmarks=0;
      double ENGmarks=0;
      for (int j=0;j<correctanswers.length;j++){
        
        if(correctanswers[(j+1).toString()]['subject']=='GK'){
         
          if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==correctanswers[(j+1).toString()]['answer']){
            GKmarks+=(correctanswers[(j+1).toString()]['mark']);
          }
          else if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==null){

          }
          else{
            GKmarks-=(widget.quizdata.data()['negmark']);
          }

        }
        if(correctanswers[(j+1).toString()]['subject']=='LR'){
          if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==correctanswers[(j+1).toString()]['answer']){
            LRmarks+=(correctanswers[(j+1).toString()]['mark']);
          }
          else if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==null){

          }
          else{
            LRmarks-=(widget.quizdata.data()['negmark']);
          }

        }
        if(correctanswers[(j+1).toString()]['subject']=='ENG'){
          if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==correctanswers[(j+1).toString()]['answer']){
            ENGmarks+=(correctanswers[(j+1).toString()]['mark']);
          }
          else if(marks[i].data()[widget.quizdata.id][(j+1).toString()]==null){

          }
          else{
            ENGmarks-=(widget.quizdata.data()['negmark']);
          }

        }
      }
      subwisewarking[marks[i].id]=[GKmarks,LRmarks,ENGmarks];
    }
    return subwisewarking;
  }

  void excelout()async{

    
    final workbook = xlsio.Workbook();
    final sheet=workbook.worksheets[0];
    List headers=['Name'];
    List maderow=[];
    for(int i=0;i<studentinfo.length;i++){
      List maderow=[];
      sheet.getRangeByIndex(i+2, 1).setText(studentinfo[i].data()['Name']);
      
      if(totalmarks()[studentinfo[i].id]!=null)
      {
        if(selectediqm==0){
          List im=individualmarking()[studentinfo[i].id];
          for (int j=0;j<(((widget.quizdata.data() as Map)['questions'])as Map).length;j++){
            maderow.add(im[j]);
            
          }
        }
        if(selectedswm==0){
          List sm=subwisemarking()[studentinfo[i].id];
          for (int j=0;j<3;j++){
            maderow.add(sm[j]);
          }
        }
        maderow.add(totalmarks()[studentinfo[i].id]);

        for(int j=0;j<maderow.length;j++){
          if(maderow[j]=="Nil"){
            sheet.getRangeByIndex(i+2, j+2).setText('Nil');
          }
          else
          {sheet.getRangeByIndex(i+2, j+2).setNumber(maderow[j]);}
        }
      
      }
      else{
        maderow.add('data not available');
        sheet.getRangeByIndex(i+2, 2).setText(maderow[0]);
      }

      
    }

    if(selectediqm==0){
      Map correctanswers=(widget.quizdata.data()['questions']);
      for (int i=0;i<correctanswers.length;i++){
        headers.add('Q${i+1}');
      }
    }
    if(selectedswm==0){
      headers.add('GK');
      headers.add('LR');
      headers.add('ENG');
    }
    headers.add('TOTAL MARKS');
    for(int i=0;i<headers.length;i++){
      sheet.getRangeByIndex(1, i+1).setText(headers[i]);
      sheet.getRangeByIndex(1, i+1).cellStyle.bold=true;
    }

    sheet.autoFitRow(1);
    sheet.autoFitColumn(1);

    final bytes=workbook.saveAsStream();

    platformspecexcel(bytes,widget.quizdata.data()['quizname']);

   

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Download result'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context,constraints) {
          double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
          return Center(
            child: Container(
              width: containerwidth,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                      children: [
                        Text('Student answers'),
                        SizedBox(
                          child: DropdownMenu(
                            
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: 0,
                                label: 'Yes'
                              ),
                              DropdownMenuEntry(
                                value: 1,
                                label: 'No'
                              )
                              
                            ],
                            onSelected: (value) {
                              selectediqm=value!;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subject wise marking'),
                        SizedBox(
                          child: DropdownMenu(
                            
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: 0,
                                label: 'Yes'
                              ),
                              DropdownMenuEntry(
                                value: 1,
                                label: 'No'
                              )
                              
                            ],
                            onSelected: (value) {
                              selectedswm=value!;
                            },
                          ),
                        )
                      ],
                    ),
                    
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                      ),
                      onPressed: () async{
                        final gen = generator(quizid: '');

  // Wait until first snapshots from both listeners are received
                        //await gen.ready;

                        // Now it's safe to access data
                        studentinfo = gen.studentinfo;
                        marks = gen.marks;

                        print("Students: ${studentinfo.length}");
                        print("Marks: ${marks.length}");
                        
                        excelout();
                        

                        
                      },
                      child: Text('Download excel'),
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
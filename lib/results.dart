import 'package:flutter/material.dart';
import 'package:lawtustutor/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class StudentDataSource extends DataGridSource {
  late List<DataGridRow> _rows;

  StudentDataSource(List<Map> students) {
    _rows = students.map((student) {
      List keyslist = student.keys.toList();
      return DataGridRow(cells: List.generate(
        keyslist.length,
        (index){
          if(index==0){
            return DataGridCell(columnName: 'name', value: student['name']);
          }
          else if(index==keyslist.length-1){
            return DataGridCell(columnName: 'date', value: student['date']);
          }
          else if(index==keyslist.length-2){
            return DataGridCell(columnName: 'total', value: student['total']);
          }
          return DataGridCell(columnName: (index).toString(), value: student[(index).toString()]);
        }
      ));
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}

class resultpage extends StatefulWidget {
  final quizid;
  const resultpage({required this.quizid,super.key});

  @override
  State<resultpage> createState() => _resultpageState();
}

class _resultpageState extends State<resultpage> {

  Map totalmarks(questioninfo,Map answers){
    Map correctanswers=(questioninfo['questions']);
    double negmark=(questioninfo['negmark']).toDouble();
    double total=0;
      for (int i=0;i<correctanswers.length;i++){
        if(correctanswers[(i+1).toString()]['answer']==answers[(i+1).toString()]){
          
          total+=correctanswers[(i+1).toString()]['mark'].toDouble();
        }
        else if(answers[(i+1).toString()]==null){
          total+=0.00;
        }
        else{
          total-=negmark;
        }
        
      }
      answers['total']=total;
      
      
    
    return answers;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context,constraints) {
            double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
            return Center(
              child: SizedBox(
                width: containerwidth,
                child: ValueListenableBuilder(
                  valueListenable: context.read<generator>().dataupdated,
                  builder: (context, value, child) {
                    if(context.read<generator>().isLoading){
                 
                      return Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                   
                    List markslistraw=context.read<generator>().marks;
                    List studentslist=context.read<generator>().studentinfo;
                    Map questioninfo=context.read<generator>().questioninfo!;

                    
                    
                    
                    Map marksfortotalmarkscalc={};
                    List<Map> listforsfgrid=[];
                    for(int i=0;i<markslistraw.length;i++){
                      
                      if((markslistraw[i].data() as Map).keys.toList().contains(widget.quizid)){
                        Map each=markslistraw[i].data()[widget.quizid]['answers'];
                        each['name']=(studentslist.singleWhere((element){
                          return element.id==markslistraw[i].id;
                        })).data()['name'];
                        each['date']=markslistraw[i].data()[widget.quizid]['startedtime'].toDate();
                        each=totalmarks(questioninfo,each);

                        listforsfgrid.add(each);

                        
                        
                        marksfortotalmarkscalc[markslistraw[i].id]=markslistraw[i].data()[widget.quizid];
                        
                      }
                    }
                    print(listforsfgrid);
                    
                    List questions=questioninfo['questions'].keys.toList();
                    
                    final dataSource = StudentDataSource(listforsfgrid);
                    return Center(
                      child: SfDataGrid(
                        allowSorting: true,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthMode: ColumnWidthMode.auto,
                        
                        source: dataSource,
                        columns: List.generate(
                          questions.length+3,
                          (index){
                            if(index==0){
                              return GridColumn(
                                columnName: 'name',
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                ),
                              );
                            }
                            else if(index==questions.length+1){
                              return GridColumn(
                                columnName: 'total',
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                ),
                              );
                            }
                            else if(index==questions.length+2){
                              return GridColumn(
                                columnName: 'date',
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Time',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                ),
                              );
                            }
                            return GridColumn(
                              columnName: (index).toString(),
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text((index).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              )
                            );
                          }
                        )
                      ),
                    );
                  }
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

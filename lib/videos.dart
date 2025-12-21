import 'package:flutter/material.dart';
import 'package:lawtustutor/addvideopage.dart';
import 'package:lawtustutor/provider.dart';
import 'package:lawtustutor/videosshow.dart';
import 'package:provider/provider.dart';

class videobatchpage extends StatefulWidget {
  const videobatchpage({super.key});

  @override
  State<videobatchpage> createState() => _videobatchpageState();
}

class _videobatchpageState extends State<videobatchpage> {

  List videoinfo=[];
  List batchinfo=[];


  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Select the batch'),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>addvideopage(index: 0,)));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerwidth= constraints.maxWidth>600?600:(constraints.maxWidth)*0.9;
          return Center(
            child: Container(
              width: containerwidth,
              child: ValueListenableBuilder(
                valueListenable: context.watch<generator1>().batchinfoupdated,
                builder: (context, value, child) {
                  batchinfo=context.watch<generator1>().batchinfo;
                  return Column(
                    children: List.generate(
                      batchinfo.length,
                      (index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              minimumSize: WidgetStatePropertyAll(Size(double.infinity,50)),
                              backgroundColor: WidgetStatePropertyAll(Colors.black),
                              foregroundColor: WidgetStatePropertyAll(Colors.white)
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider.value(value: generator2(),child: videosshowpage(batchname: batchinfo[index].data()['batch'],))));
                            },
                            child: Text(batchinfo[index].data()['batch']),
                          ),
                        );
                      }
                    )
                  );
                }
              ),
            ),
          );
        },
      ),
    );
  }
}
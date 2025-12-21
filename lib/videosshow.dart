import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:lawtustutor/addvideopage.dart';
import 'package:lawtustutor/provider.dart';
import 'package:provider/provider.dart';

class videosshowpage extends StatefulWidget {

  final batchname;

  const videosshowpage({required this.batchname,super.key});

  @override
  State<videosshowpage> createState() => _videosshowpageState();
}

class _videosshowpageState extends State<videosshowpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Videos'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerwidth= constraints.maxWidth>600?600:(constraints.maxWidth)*0.9;
          return Center(
            child: Container(
              width: containerwidth,
              child: ValueListenableBuilder(
                valueListenable: context.watch<generator2>().videoinfoupdated,
                builder: (context, value, child) {
                  
                  final videoinfo=context.watch<generator2>().videoinfo;
                  if(videoinfo.isEmpty){
                    return Center(child: Text('Nothing'),);
                  }
                
                  Map videoinforefined={};
                  for (int i=0;i<(videoinfo).length;i++){
                    print((videoinfo[(i+1).toString()]['batch']));
                    if((videoinfo[(i+1).toString()]['batch']as List).contains(widget.batchname)){
                      
                      videoinforefined[(i+1).toString()]=videoinfo[(i+1).toString()];
                      print(videoinforefined);
                    }
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.8),
                    itemCount:videoinforefined.length ,
                    itemBuilder: (context, index) {
                      final videoinfodata=videoinforefined[(index+1).toString()];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(Colors.black),
                            backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 223, 223, 223)),
                            fixedSize: WidgetStatePropertyAll(Size(200,300)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>addvideopage(index: (index+1).toString())));
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ExtendedImage.network(

                                  cache: false,
                                  'https://lawtusbackend.onrender.com/getimg?dir=${videoinfodata['img']}'
                                ),
                              ),
                              
                              SizedBox(height: 10,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(videoinfodata['name']),
                                    Text(videoinfodata['faculty']),
                                    Text(videoinfodata['subject']),
                                  ],
                                ),
                              ),
                                    
                            ],
                          ),
                        ),
                      );
                    },
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
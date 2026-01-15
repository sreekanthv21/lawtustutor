import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawtustutor/Listpage.dart';
import 'package:lawtustutor/Quizmakepage.dart';
import 'package:lawtustutor/batches.dart';
import 'package:lawtustutor/makequizfirstpage.dart';
import 'package:lawtustutor/provider.dart';
import 'package:lawtustutor/videos.dart';
import 'package:provider/provider.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints)
          {double containerwidth= constraints.maxWidth>600?1000:(constraints.maxWidth)*0.9;
            return Center(
          child: Container(
            width: containerwidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300,50)),
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider.value(value: generator1(),child: makequizfirstpage())));
                  },
                  child: Text('Create quiz',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 30,)
,                TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300,50)),
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider.value(value: generator4(),child: Listpage())));
                  },
                  child: Text('List quiz',style: TextStyle(color: Colors.white)),
                  
                ),
                SizedBox(height: 30,),
                TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300,50)),
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>batch()));
                  },
                  child: Text('Batch',style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 30,),
                TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(300,50)),
                    backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 255, 0, 0)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeNotifierProvider.value(value: generator1(),child: ChangeNotifierProvider.value(value: generator2(),child: videobatchpage()))));
                  },
                  child: Text('Videos',style: TextStyle(color: Colors.white)),
                ),
                Text('hi')
                
                
              ],
            ),
          ),
                );}
        )),
    );
  }
}
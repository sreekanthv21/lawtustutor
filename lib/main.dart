import 'package:flutter/material.dart';
import 'package:lawtustutor/finalisingpage.dart';
import 'package:lawtustutor/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lawtustutor/firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  try
{  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  
  
}catch(e){
  print(e);
}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
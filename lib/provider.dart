import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// students and marks
// batches
// videos
// students
// tests

class generator extends ChangeNotifier {

  List studentinfo = [];
  List marks = [];
  Map? questioninfo = {};

  bool streaminitialised = false;
  ValueNotifier dataupdated = ValueNotifier(false);

  bool marksLoading = true;
  bool studentsLoading = true;
  bool questionsLoading = true;

  bool get isLoading {
    if (marksLoading == false &&
        studentsLoading == false &&
        questionsLoading == false) {
      return false;
    }
    return true;
  }

  String quizid;

  generator({required this.quizid}) {
    if (streaminitialised == false) {
      streamgetter();
    }
  }

  void streamgetter() async{
    try {
      final res1=await FirebaseFirestore.instance.collection('students').get();
      studentinfo = res1.docs;
      dataupdated.value = !dataupdated.value;
      studentsLoading = false;
      notifyListeners();

      final res2=await FirebaseFirestore.instance.collection('marks').get();
      marks = res2.docs;
      dataupdated.value = !dataupdated.value;
      marksLoading = false;
      notifyListeners();

      final res3=await FirebaseFirestore.instance.collection('tests').doc(quizid).get();
      if(res3.data() ==null){
          questioninfo={};
        }
        else if(res3.data()!=null)
        {questioninfo = res3.data();}
        dataupdated.value = !dataupdated.value;
        questionsLoading = false;
        notifyListeners();

      streaminitialised = true;
    } catch (e) {
      streaminitialised = false;
    }
  }
}



class generator1 extends ChangeNotifier{

  static generator1? _instance;

  List batchinfo=[];
  ValueNotifier batchinfoupdated=ValueNotifier(true);


  bool streaminitialised=false;
  bool initialising=false;

  
  final Completer<void> _ready = Completer<void>();

  
  Future<void> get ready => _ready.future;

  generator1._internal();

  factory generator1(){
    if(_instance==null){
      _instance=generator1._internal();
    }
    else{
      _instance=_instance;
    }
    if(_instance!.streaminitialised==false && _instance!.initialising==false){
      _instance!.streamgetter();
      _instance!.initialising=true;
    }
    return _instance!;
  }
  
  bool isLoading=true;


  void streamgetter(){
    int readyCount=0;

    try{
      FirebaseFirestore.instance.collection('batches').snapshots().listen((snapshot){
        batchinfo=snapshot.docs;
        batchinfoupdated.value=!batchinfoupdated.value;
        isLoading=false;
        notifyListeners();
        
        if (++readyCount == 1 && !_ready.isCompleted) {
          _ready.complete();
          
        }
        
        
      },onError: (e){
        initialising=false;
      }
      );
      
      
    }catch(e){
      initialising=false;
      streaminitialised=false;
    }

  }

}

class generator2 extends ChangeNotifier{

  static generator2? _instance;

  Map videoinfo={};
  ValueNotifier videoinfoupdated=ValueNotifier(true);


  bool streaminitialised=false;
  bool initialising=false;

  
  final Completer<void> _ready = Completer<void>();

  
  Future<void> get ready => _ready.future;

  generator2._internal();

  factory generator2(){
    if(_instance==null){
      _instance=generator2._internal();
    }
    else{
      _instance=_instance;
    }
    if(_instance!.streaminitialised==false && _instance!.initialising==false){
      _instance!.streamgetter();
      _instance!.initialising=true;
    }
    return _instance!;
  }
  

  void streamgetter(){
    int readyCount=0;

    try{
      FirebaseFirestore.instance.collection('videos').doc('lawtusvids').snapshots().listen((snapshot){
        videoinfo=snapshot.data()!;
        videoinfoupdated.value=!videoinfoupdated.value;
        notifyListeners();
        
        if (++readyCount == 1 && !_ready.isCompleted) {
          _ready.complete();
          
        }
        
        
      },onError: (e){
        initialising=false;
      }
      );
      
      
    }catch(e){
      initialising=false;
      streaminitialised=false;
    }

  }

}
class generator3 extends ChangeNotifier{

  static generator3? _instance;

  generator3._internal();

  factory generator3(){
    if(_instance==null){
      _instance= generator3._internal();
    }
    else{
      _instance=_instance;
    }
    if(_instance!.streaminitialised==false){
      _instance!.streamgetter();
    }
    return _instance!;
  }

  bool isLoading=true;

  bool streaminitialised=false;
  final ValueNotifier<bool> studentsinfoupdated = ValueNotifier(false);


  List studentsinfo=[];
  StreamSubscription? sub1;

  
  
  void streamgetter(){
    try{
      sub1=FirebaseFirestore.instance.collection('students').snapshots().listen((snapshot) {
        studentsinfo = snapshot.docs;
        isLoading=false;
        studentsinfoupdated.value = !studentsinfoupdated.value;
        notifyListeners();
      });

    
    streaminitialised=true;
    }catch(e){
      streaminitialised=false;
    }
  }

  void reset() {
    sub1?.cancel();

    streaminitialised = false;
    _instance = null;
  }
}

class generator4 extends ChangeNotifier{

  static generator4? _instance;

  generator4._internal();

  factory generator4(){
    if(_instance==null){
      _instance= generator4._internal();
    }
    else{
      _instance=_instance;
    }
    if(_instance!.streaminitialised==false){
      _instance!.streamgetter();
    }
    return _instance!;
  }

  bool isLoading=true;

  bool streaminitialised=false;
  final ValueNotifier<bool> quizlistinfoupdated = ValueNotifier(false);


  List quizlist=[];
  StreamSubscription? sub1;

  
  
  void streamgetter(){
    try{
      sub1=FirebaseFirestore.instance.collection('tests').orderBy('creationtime',descending: true).snapshots().listen((snapshot) {
        quizlist = snapshot.docs; 
        isLoading=false;
        quizlistinfoupdated.value = !quizlistinfoupdated.value;
        notifyListeners();
      });

    
    streaminitialised=true;
    }catch(e){
      streaminitialised=false;
    }
  }

  void reset() {
    sub1?.cancel();

    streaminitialised = false;
    _instance = null;
  }
}

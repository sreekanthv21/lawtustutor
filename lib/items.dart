import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
Padding field(text,controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: 5,
        minLines: 1,
        controller: controller,
        
        decoration: InputDecoration(
          
          
          hintText: text,
          filled: true,
          fillColor: const Color.fromARGB(255, 211, 211, 211),
          border: OutlineInputBorder(borderSide: BorderSide.none)
        ),
      ),
    );}



String converttodate(date){
  return '${date.day}-${date.month}-${date.year}';
  
}
String converttotime(date){
  
  return DateFormat('hh:mm a').format(date);
}

Container timecontainer(int index,data) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5)

      ),
      child: Text(data,style: TextStyle(color: Colors.white),));
  }

String converttodateandtime(date){
  return '${date.day}-${date.month}-${date.year}  ${DateFormat('hh:mm a').format(date)}';
}
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    body: Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text("System Security V1.0", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 40),
          TextField(decoration: InputDecoration(labelText: "Gmail", border: OutlineInputBorder())),
          SizedBox(height: 15),
          TextField(decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()), obscureText: true),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // هنا تظهر رسالة المقلب بعد ما يضغط الزر
              print("Caught one!"); 
            },
            child: Text("تسجيل الدخول وفحص التهديدات"),
          ),
        ],
      ),
    ),
  ),
));

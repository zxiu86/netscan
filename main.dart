import 'package:flutter/material.dart';

void main() => runApp(FakeLoginApp());

class FakeLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, size: 80, color: Colors.blue),
              SizedBox(height: 20),
              Text("Security Check V1.0", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              TextField(decoration: InputDecoration(labelText: "Gmail")),
              TextField(decoration: InputDecoration(labelText: "Password"), obscureText: true),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // هنا تطلع رسالة المقلب
                  print("Target Spotted!"); 
                },
                child: Text("Start System Scan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

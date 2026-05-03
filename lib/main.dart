import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: SecurityApp(),
));

class SecurityApp extends StatefulWidget {
  @override
  _SecurityAppState createState() => _SecurityAppState();
}

class _SecurityAppState extends State<SecurityApp> {
  // معرفات الحقول علمود نكدر نقرأ اللي انكتب
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void runScan() {
    // هذي الحركة تطلع "لودينج" لثواني علمود المصدقية
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context); // يغلق اللودينج
          showPrankResult(); // يظهر المقلب
        });
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("جاري فحص أمان الجهاز..."),
            ],
          ),
        );
      },
    );
  }

  void showPrankResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("⚠️ تم اكتشاف ثغرة غباء!"),
        content: Text("عزيزي صاحب الإيميل: ${emailController.text}\n\nتم سحب بياناتك بنجاح! روح انطي طيزك لزيزو وإلا الموبايل ينفجر بيدك🥤💣"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("خوش، رايح أجيب")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_person, size: 90, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text("Security Check Pro", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Gmail", border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passController,
                decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: runScan,
                  child: Text("بدء فحص الحماية"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

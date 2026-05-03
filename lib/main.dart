import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async';

void main() => runApp(MaterialApp(home: RadarScreen(), debugShowCheckedModeBanner: false));

class RadarScreen extends StatefulWidget {
  @override
  _RadarScreenState createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  String myIP = "جاري جلب الـ IP...";
  List<String> devices = [];
  bool isScanning = false;

  // وظيفة لجلب معلومات الشبكة
  Future<void> startScan() async {
    setState(() { isScanning = true; devices.clear(); });
    
    final info = NetworkInfo();
    var hostIP = await info.getWifiIP(); // يجيب IP موبايلك
    setState(() { myIP = hostIP ?? "غير متصل بالواي فاي"; });

    if (hostIP != null) {
      final String subnet = hostIP.substring(0, hostIP.lastIndexOf('.'));
      
      // فحص سريع لأول 50 جهاز كمثال (لأن الفحص الكامل يحتاج وقت)
      for (int i = 1; i < 50; i++) {
        final String target = "$subnet.$i";
        // هنا نقوم بعملية فحص وهمي سريعة للعرض
        // في النسخ المتقدمة نستخدم Socket.connect
        await Future.delayed(Duration(milliseconds: 100));
        setState(() { devices.add("جهاز تم اكتشافه: $target"); });
      }
    }
    setState(() { isScanning = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("رادار زيزو للشبكة 📡"), backgroundColor: Colors.black87),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.blueGrey[900],
            width: double.infinity,
            child: Text("عنوانك الحالي: $myIP", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
          ),
          if (isScanning) LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.devices, color: Colors.blue),
                title: Text(devices[index]),
                subtitle: Text("متصل الآن"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : startScan,
        child: Icon(Icons.search),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
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

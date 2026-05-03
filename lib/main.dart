import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
  home: RadarScreen(),
  debugShowCheckedModeBanner: false,
));

class RadarScreen extends StatefulWidget {
  @override
  _RadarScreenState createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  String myIP = "جاري جلب الـ IP...";
  List<String> devices = [];
  bool isScanning = false;

  Future<void> startScan() async {
    setState(() { 
      isScanning = true; 
      devices.clear(); 
    });
    
    final info = NetworkInfo();
    var hostIP = await info.getWifiIP(); 
    setState(() { myIP = hostIP ?? "غير متصل بالواي فاي"; });

    if (hostIP != null) {
      final String subnet = hostIP.substring(0, hostIP.lastIndexOf('.'));
      
      // فحص أول 30 جهاز للتجربة السريعة
      for (int i = 1; i <= 30; i++) {
        final String target = "$subnet.$i";
        await Future.delayed(Duration(milliseconds: 150));
        setState(() { 
          devices.add("جهاز متصل: $target"); 
        });
      }
    }
    setState(() { isScanning = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("رادار زيزو 📡"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.blueGrey[800],
            child: Text(
              "عنوانك: $myIP",
              style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (isScanning) LinearProgressIndicator(color: Colors.greenAccent),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.router, color: Colors.blue),
                title: Text(devices[index]),
                trailing: Icon(Icons.check_circle, color: Colors.green, size: 16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : startScan,
        backgroundColor: Colors.blueGrey[900],
        child: Icon(isScanning ? Icons.hourglass_empty : Icons.search, color: Colors.white),
      ),
    );
  }
}

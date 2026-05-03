import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'dart:async';

void main() => runApp(MaterialApp(home: ZizoRadar(), debugShowCheckedModeBanner: false));

class ZizoRadar extends StatefulWidget {
  @override
  _ZizoRadarState createState() => _ZizoRadarState();
}

class _ZizoRadarState extends State<ZizoRadar> {
  List<String> activeDevices = [];
  bool isScanning = false;
  String status = "اضغط للبدء بالفحص بالسونار 📡";

  Future<void> startZizoScan() async {
    setState(() { isScanning = true; activeDevices.clear(); status = "جاري إرسال إشارات Ping..."; });

    final info = NetworkInfo();
    var hostIP = await info.getWifiIP();
    
    if (hostIP != null) {
      final String subnet = hostIP.substring(0, hostIP.lastIndexOf('.'));
      
      // راح نفحص أول 30 جهاز كبداية علمود السرعة
      for (int i = 1; i <= 30; i++) {
        final String target = "$subnet.$i";
        final ping = Ping(target, count: 1, timeout: 1); // نرسل إشارة واحدة فقط

        ping.stream.listen((event) {
          if (event.response != null && event.response!.ip != null) {
            if (!activeDevices.contains(target)) {
              setState(() { activeDevices.add("جهاز نشط: $target ✅"); });
            }
          }
        });
      }
    }
    
    // ننتظر شوية ونطفي اللودينج
    await Future.delayed(Duration(seconds: 5));
    setState(() { isScanning = false; status = "اكتمل الفحص بنجاح!"; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("رادار زيزو المحترف"), backgroundColor: Colors.redAccent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(status, style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          if (isScanning) LinearProgressIndicator(color: Colors.redAccent),
          Expanded(
            child: ListView.builder(
              itemCount: activeDevices.length,
              itemBuilder: (context, index) => Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: Icon(Icons.radar, color: Colors.redAccent),
                  title: Text(activeDevices[index], style: TextStyle(color: Colors.white)),
                  subtitle: Text("متصل ويستجيب للإشارة", style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : startZizoScan,
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.search),
      ),
    );
  }
}

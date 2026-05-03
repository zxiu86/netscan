import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:io';

void main() => runApp(MaterialApp(home: RealRadar(), debugShowCheckedModeBanner: false));

class RealRadar extends StatefulWidget {
  @override
  _RealRadarState createState() => _RealRadarState();
}

class _RealRadarState extends State<RealRadar> {
  List<String> activeDevices = [];
  bool isScanning = false;
  String status = "اضغط للبدء بالفحص الحقيقي";

  Future<void> scanNetwork() async {
    setState(() { isScanning = true; activeDevices.clear(); status = "جاري فحص الأجهزة المتصلة..."; });

    final info = NetworkInfo();
    var hostIP = await info.getWifiIP();
    
    if (hostIP != null) {
      final String subnet = hostIP.substring(0, hostIP.lastIndexOf('.'));
      
      // راح نفحص أول 50 عنوان بالشبكة
      for (int i = 1; i <= 50; i++) {
        final String target = "$subnet.$i";
        try {
          // نحاول نفتح اتصال سريع (بورت 80 أو 443) للتأكد من وجود الجهاز
          final socket = await Socket.connect(target, 80, timeout: Duration(milliseconds: 100));
          setState(() { activeDevices.add("جهاز نشط: $target"); });
          socket.destroy();
        } catch (e) {
          // إذا ما رد الجهاز، معناها ماكو شي هنا
        }
      }
      setState(() { status = "اكتمل الفحص. وجدنا ${activeDevices.length} أجهزة"; });
    }
    setState(() { isScanning = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("رادار زيزو الحقيقي 🛡️"), backgroundColor: Colors.indigo),
      body: Column(
        children: [
          Container(padding: EdgeInsets.all(15), child: Text(status, style: TextStyle(fontWeight: FontWeight.bold))),
          if (isScanning) LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: activeDevices.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.wifi_tethering, color: Colors.green),
                title: Text(activeDevices[index]),
                subtitle: Text("متصل الآن بالراوتر"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : scanNetwork,
        child: Icon(Icons.radar),
      ),
    );
  }
}
      }
      setState(() { status = "اكتمل الفحص. وجدنا ${activeDevices.length} أجهزة"; });
    }
    setState(() { isScanning = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("رادار زيزو الحقيقي 🛡️"), backgroundColor: Colors.indigo),
      body: Column(
        children: [
          Container(padding: EdgeInsets.all(15), child: Text(status, style: TextStyle(fontWeight: FontWeight.bold))),
          if (isScanning) LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: activeDevices.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.wifi_tethering, color: Colors.green),
                title: Text(activeDevices[index]),
                subtitle: Text("متصل الآن بالراوتر"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : scanNetwork,
        child: Icon(Icons.radar),
      ),
    );
  }
}

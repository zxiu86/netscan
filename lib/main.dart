import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MaterialApp(
  home: ScronHome(),
  debugShowCheckedModeBanner: false,
  theme: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF050505), // أسود ملكي
  ),
));

class ScronHome extends StatefulWidget {
  @override
  _ScronHomeState createState() => _ScronHomeState();
}

class _ScronHomeState extends State<ScronHome> {
  List apps = [];
  bool isLoading = true;
  final String rawUrl = "https://raw.githubusercontent.com/zxiu86/scron-data/main/data.json";

  @override
  void initState() {
    super.initState();
    injectData();
  }

  // ميزة التحديث (Refresh) 🔄
  Future<void> injectData() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(rawUrl), headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          apps = data['apps'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل التحديث: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text("SCRON HUB", style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900, color: Colors.cyanAccent)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 10,
        shadowColor: Colors.cyanAccent.withOpacity(0.3),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.cyanAccent), onPressed: injectData)
        ],
      ),

      // إضافة السحب للتحديث 🔄
      body: RefreshIndicator(
        onRefresh: injectData,
        color: Colors.cyanAccent,
        child: isLoading 
            ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: apps.length,
                itemBuilder: (context, index) => AppNeonCard(app: apps[index]),
              ),
      ),
    );
  }
}

class AppNeonCard extends StatelessWidget {
  final dynamic app;
  const AppNeonCard({Key? key, required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.cyanAccent.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            // الأيقونة مع معالجة الأخطاء 🖼️
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: app['iconUrl'] ?? "",
                width: 65, height: 65, fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[900]),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.cyanAccent, size: 40),
              ),
            ),
            const SizedBox(width: 15),
            // تفاصيل التطبيق 📝
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app['name'] ?? "Unknown", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(app['category'] ?? "General", style: const TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(app['description'] ?? "", maxLines: 2, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
            // زر التحميل الحقيقي 📥
            IconButton(
              icon: const Icon(Icons.cloud_download_rounded, color: Colors.cyanAccent, size: 35),
              onPressed: () async {
                final url = Uri.parse(app['downloadUrl'] ?? "");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("رابط التحميل غير صالح!")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

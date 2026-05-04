import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MaterialApp(
  home: ScronHome(),
  debugShowCheckedModeBanner: false,
  theme: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
  ),
));

class ScronHome extends StatefulWidget {
  @override
  _ScronHomeState createState() => _ScronHomeState();
}

class _ScronHomeState extends State<ScronHome> {
  List apps = [];
  bool isLoading = true;
  String status = "جاري جلب الحقنة... 💉";
  
  // الرابط الخام (تأكد من صحته)
  final String rawUrl = "https://raw.githubusercontent.com/zxiu86/scron-data/main/data.json";

  @override
  void initState() {
    super.initState();
    injectData();
  }

  Future<void> injectData() async {
    try {
      final response = await http.get(
        Uri.parse(rawUrl),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          apps = data['apps'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          status = "خطأ في السيرفر: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        status = "فشل الاتصال: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SCRON", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : apps.isEmpty 
              ? Center(child: Text(status, style: const TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: apps.length,
                  itemBuilder: (context, index) => AppCard(app: apps[index]),
                ),
    );
  }
} // إغلاق كلاس _ScronHomeState بشكل صحيح هنا ✅

class AppCard extends StatelessWidget {
  final dynamic app;
  const AppCard({Key? key, required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: app['iconUrl'] ?? '',
            width: 55, height: 55,
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) => const Icon(Icons.apps, color: Colors.blueAccent),
          ),
        ),
        title: Text(app['name'] ?? 'بدون اسم', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(app['category'] ?? 'عام', style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
            const SizedBox(height: 5),
            Text(app['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download_for_offline, color: Colors.blueAccent, size: 30),
          onPressed: () async {
            final url = Uri.parse(app['downloadUrl'] ?? '');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:poc_glow/ui/main_screen_provider.dart';

import 'data/url_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(const MyApp());
}

const primaryColor = Color(0xFF0066FF);
const backgroundColor = Color(0xFFFFFFFF);

const Map<String, String> envUrls = {
  "dev03": "platform-api.dev03.glowfinsvs.com",
  "qa03": "platform-api.qa03.glowfinsvs.com",
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: EeUrlProvider.init(),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'PoC Glow',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                elevation: 0,
                foregroundColor: primaryColor,
                backgroundColor: backgroundColor,
              ),
              scaffoldBackgroundColor: backgroundColor,
            ),
            home: SafeArea(
              child: snapshot.connectionState == ConnectionState.done
                  ? const MainScreenProvider()
                  : const Scaffold(body: Center(child: CircularProgressIndicator())),
            ),
          );
        });
  }
}

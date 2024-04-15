import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniblog/screens/mini_blog_homepage.dart';
import 'package:miniblog/themes/mini_blog_darktheme.dart';
import 'package:miniblog/themes/mini_blog_lighttheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  ThemeMode themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _readThemeData();
  }

  _readThemeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isDark = preferences.getBool("DARKTHEME");
    if (isDark != null && isDark) {
      setState(() {
        themeMode = ThemeMode.dark;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darktheme,
        themeMode: themeMode,
        home: const HomePage(),
      ),
    );
  }
}

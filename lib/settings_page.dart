import 'package:flutter/material.dart';


class Settings extends StatefulWidget {
  const Settings({super.key, required this.title});
  final String title;




  @override
  State<Settings> createState() => _Settings();
}




class _Settings extends State<Settings>{
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: mode, // Decides which theme to show, light or dark.
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => _notifier.value = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
                child: const Text('Toggle Theme'),
              ),
            ),
          ),
        );
      },
    );
  }
}


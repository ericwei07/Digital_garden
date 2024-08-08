import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:happy_digital_garden/pages/starter_page_controller.dart';

import 'pages/links_page.dart';
import 'pages/log_in_page.dart';
import 'pages/other_garden_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/user_garden_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'happy digital garden',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Digital garden'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StarterPageController _starterPageController;

  @override
  void initState() {
    _starterPageController = StarterPageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _starterPageController.checkToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _starterPageController.tokenValid ? const MainPage(title: 'main page',) : Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LogInPage(title: 'Log in');
                  }
                ),
              ),
              child: const Text("Log in"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return const SignUpPage(title: 'Sign up');
                  }
                ),
              ),
              child: const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAlignment = -1.0;
  int currentPageIndex = 1;

  IndexedStack _getPage(int index) {
    return IndexedStack(
      index: index,
      children: const [
        ProfileContent(title: "User profile"),
        MyGardenContent(title: "Your garden"),
        AllGardenContent(title: "Explore other gardens"),
        MyLinks(title: "Your links"),
        Settings(title: "Settings")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: currentPageIndex,
            groupAlignment: groupAlignment,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            labelType: labelType,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.account_box_outlined),
                selectedIcon: Icon(Icons.account_box_rounded),
                label: Text('Profile'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Your garden'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: Text('All articles'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.link),
                selectedIcon: Icon(Icons.link),
                label: Text('Links'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_applications_outlined),
                selectedIcon: Icon(Icons.settings_applications_rounded),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: _getPage(currentPageIndex),
          ), // This is the main content.
        ],
      ),
    );
  }
}

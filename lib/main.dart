import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td2/mytheme.dart';
import 'package:td2/screens/AddTask.dart';
import 'package:td2/screens/EcranSettings.dart';
import 'package:td2/screens/account_screen.dart';
import 'package:td2/screens/home_screen.dart';
import 'package:td2/screens/search_screen.dart';
import 'package:td2/models/task.dart';
import 'package:td2/viewModel/SettingViewModel.dart';
import 'package:td2/viewModel/TaskViewModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyTD2());
}

class MyTD2 extends StatelessWidget {
  const MyTD2({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, SettingViewModel notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: notifier.isDark ? MyTheme.dark() : MyTheme.light(),
            title: 'TD2',
            home: const Home(),
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    SearchScreen(tasks: []),
    const HomeScreen(),
    AccountScreen(),
    EcranSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TD2')),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButton: _selectedIndex == 1 || _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTask()),
                );
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

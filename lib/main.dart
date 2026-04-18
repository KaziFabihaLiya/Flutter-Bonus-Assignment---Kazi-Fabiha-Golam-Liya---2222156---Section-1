import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_class/firebase_options.dart';
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/screens/UI_page.dart';
import 'package:provider/provider.dart';


void main() async {
  // These 2 lines are the only addition for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FlutterUIApp());
}

class FlutterUIApp extends StatelessWidget {
  const FlutterUIApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> TaskManagementProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(title: 'FLUTTER UI DEMO'),
      ),
    );
  }
}



class HomePage extends StatefulWidget { 
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    print('Counter value: $_counter');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purpleAccent,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      body: Center(
        child: Container(
          height: 190,
          width: 350,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: .5),
            color: Colors.grey.withAlpha(50),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text('Counter app', style: TextStyle(fontSize: 24)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text('The current value is', style: TextStyle(fontSize: 15)),

                  SizedBox(width: 5),

                  Text(
                    _counter.toString(),
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: Colors.purpleAccent,
                    ),
                  ),

                  SizedBox(width: 5),

                  Icon(Icons.timelapse, color: Colors.purpleAccent, size: 30),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text('Increment Counter'),
                  ),

                  SizedBox(width: 20),

                  IconButton(
                    onPressed: (){
                      // home -> page 2 -> page 3 -> page 4 -> page 5

                      // |Page 5 |
                      // |Page 4 |
                      // |Page 3 |
                      // |Page 2 |  
                      // |Home   |

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UiPage(),)
                      );


                    },
                    color: Colors.purpleAccent,
                    iconSize: 40,
                    icon: Icon(Icons.arrow_circle_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
          _incrementCounter();
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}

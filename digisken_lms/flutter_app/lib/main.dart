import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/providers/course_providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: MaterialApp(
        title: 'DigiSken LMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          primaryColor: Colors.blue[700],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[700],
            elevation: 2,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

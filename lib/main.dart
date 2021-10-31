import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haircut_app/components/bottom_navigation_bar.dart';
import 'package:haircut_app/routes.dart';
import 'package:haircut_app/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BadgeNotification>(create: (context) => BadgeNotification()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hair cut App',
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),),
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}

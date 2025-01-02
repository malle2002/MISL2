import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/JokeOfTheDayScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/JokeCategoryScreen.dart';
import 'screens/RandomJokeScreen.dart';
import 'services/api_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  print(token);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    if (message.notification != null) {
      print('Notification Title: ${message.notification?.title}');
      print('Notification Body: ${message.notification?.body}');
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      navigatorKey.currentState?.pushNamed('/jokeOfTheDay');
  });
  runApp(
      DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => HomeScreen(),
        '/jokeCategory': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return JokeCategoryScreen(
            type: args['type'] as String,
            favoriteJokes: args['favoriteJokes'] as List<Map<String, String>>,
            addFavorite: args['addFavorite'] as Function(String, String),
            isFavorite: args['isFavorite'] as Function(String, String, String),
          );
        },
        '/randomJoke': (context) {
          final args = ModalRoute
              .of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          return RandomJokeScreen(
            favoriteJokes: args['favoriteJokes'] as List<Map<String, String>>,
            addFavorite: args['addFavorite'] as Function(String, String),
            isFavorite: args['isFavorite'] as Function(String, String, String),
            removeFavorite: args['removeFavorite'] as Function(String, String),
          );
        },
        '/jokeOfTheDay': (context) => JokeOfTheDayScreen(),
      },
    );
  }
}

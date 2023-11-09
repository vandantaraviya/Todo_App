import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Screens/Search_Screen/search_screen.dart';
import 'package:todo_app/utils/Common/app_string.dart';
import 'Services/Pref_Res.dart';
import 'Services/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();
  await PrefService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder:(context, orientation, deviceType) => GetMaterialApp(
        theme: ThemeData(
          primarySwatch: AppColors.primaryColor,
        ),
        home: const SearchScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


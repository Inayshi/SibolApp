import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:urban_farming/change_notifiers/registration_controller.dart';
import 'package:urban_farming/core/constants.dart';
import 'package:urban_farming/pages/main_page.dart';
import 'package:urban_farming/pages/registration_page.dart';
import 'package:urban_farming/services/auth_service.dart';
import 'firebase_options.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegistrationController()),
      ],
      child: MaterialApp(
        title: 'Awesome Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          useMaterial3: true,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: background,
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                backgroundColor: background,
                titleTextStyle: const TextStyle(
                  color: Colors.amber,
                  fontSize: 32,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
        home: StreamBuilder<User?>(
          stream: AuthService.userStream,
          builder: (context, snapshot) {
            // return snapshot.hasData && AuthService.isEmailVerified
            return snapshot.hasData
                ? const MainPage()
                : const RegistrationPage();
          },
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized successfully!");
  runApp(const LoginPage());
}

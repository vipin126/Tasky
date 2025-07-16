import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/View/screens/Homepage.dart';
import 'package:tasky/View/screens/OnBoardingScreen.dart';
import 'package:tasky/ViewModel/AuthViewModel.dart';
import 'package:tasky/firebase_options.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

runApp(
const ProviderScope(
      child: MyApp(),
    ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
   final authstate=ref.watch(firebaseAuthStateProvider);
   
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: authstate.when(
        data: (user) {
          // If user is logged in, go to HomeScreen, otherwise Onboarding
          return user != null ? HomeScreen() : OnboardingScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Text('Error initializing auth: $error'),
          ),
        ),
      ),
    );
  }
}

final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
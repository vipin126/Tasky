
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Const/TextStyle.dart';
import 'package:tasky/View/Buttons/Buttons.dart';
import 'package:tasky/View/screens/Homepage.dart';
import 'package:tasky/View/screens/SignUpScreen.dart';
import 'package:tasky/ViewModel/AuthViewModel.dart';


class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the loading state from the authViewModelProvider
    final authState = ref.watch(authViewModelProvider);

    // Listen for error messages from the authViewModelProvider
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return AuthScreenScaffold(
      title: 'Welcome back!',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EMAIL ADDRESS',
            style: AppTextStyles.inputLabel,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Laura@gmail.com',
              filled: true,
              fillColor: AppColors.lightGrey.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: const Icon(Icons.check, color: AppColors.primaryPurple),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PASSWORD',
            style: AppTextStyles.inputLabel,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: '********',
              filled: true,
              fillColor: AppColors.lightGrey.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: const Icon(Icons.visibility_off, color: AppColors.darkGrey),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: Text(
                'Forgot password?',
                style: AppTextStyles.linkText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          authState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  text: 'Log In',
                  onPressed: () {
                    // Call the signIn method from the ViewModel
                    ref.read(authViewModelProvider.notifier).signIn(
                          _emailController.text,
                          _passwordController.text,
                        );


print("sign se phale");
                         if( authState.isLoggedin){
                    
                    print("sigin successfully called");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );}
                  },
                ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'or log in with',
              style: AppTextStyles.bodyText.copyWith(color: AppColors.darkGrey),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialAuthButton(
                iconPath: 'f', // Placeholder for Facebook icon
                backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                onPressed: () {
                 
                },
              ),
              const SizedBox(width: 16),
              SocialAuthButton(
                iconPath: 'G', // Placeholder for Google icon
                backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                onPressed: () {
                  // Handle Google login
                },
              ),
              const SizedBox(width: 16),
              SocialAuthButton(
                iconPath: '', // Placeholder for Apple icon
                backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                onPressed: () {
                 
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: AppTextStyles.bodyText,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text(
                  'Get started!',
                  style: AppTextStyles.linkText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class AuthScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const AuthScreenScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Top icon/logo as seen in the designs
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.check_box, // Or a custom SVG if available
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                title,
                style: AppTextStyles.authTitle,
              ),
              const SizedBox(height: 32),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
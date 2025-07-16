import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Const/TextStyle.dart';
import 'package:tasky/View/Buttons/Buttons.dart';
import 'package:tasky/View/screens/Homepage.dart';
import 'package:tasky/View/screens/LoginScreen.dart';
import 'package:tasky/ViewModel/AuthViewModel.dart';


class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

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
      title: 'Let\'s get started!',
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
              hintText: 'Enter your email',
              filled: true,
              fillColor: AppColors.lightGrey.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            ),
          ),
          const SizedBox(height: 32),
          authState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  text: 'Sign up',
                  onPressed: () {
                    // Call the signup method from the ViewModel
                    ref.read(authViewModelProvider.notifier).signUp(
                          _emailController.text,
                          _passwordController.text,
                        );
                 if( authState.isLoggedin){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );}
                  
                  }
                  ,
                ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'or sign up with',
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
                  // Handle Facebook signup
                },
              ),
              const SizedBox(width: 16),
              SocialAuthButton(
                iconPath: 'G', // Placeholder for Google icon
                backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                onPressed: () {
                  // Handle Google signup
                },
              ),
              const SizedBox(width: 16),
              // SocialAuthButton(
              //   iconPath: '', // Placeholder for Apple icon
              //   backgroundColor: AppColors.lightGrey.withOpacity(0.3),
              //   onPressed: () {
              //     // Handle Apple signup
              //   },
              // ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already an account?',
                style: AppTextStyles.bodyText,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'Log In',
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
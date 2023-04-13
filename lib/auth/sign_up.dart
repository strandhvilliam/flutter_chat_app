import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_input.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;

    try {
      final user = await SupabaseService.signUp(email, password, username);
      if (mounted && user != null) {
        context.go('/chats');
        context.showSnackBar(message: 'Successfully signed up!');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(message: 'Successfully signed up!');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 200),
              AuthInputField(
                controller: _emailController,
                label: 'Email',
                validator: (String? value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              AuthInputField(
                controller: _usernameController,
                label: 'Username',
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              AuthInputField(
                controller: _passwordController,
                obscureText: true,
                label: 'Password',
                validator: (String? value) {
                  if (value!.isEmpty || value.length <= 6) {
                    return 'Please enter a password with at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp();
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  context.go('/sign-in');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

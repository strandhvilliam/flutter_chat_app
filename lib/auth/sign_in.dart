import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/supabase.dart';
import 'package:go_router/go_router.dart';

import 'auth_input.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await SupabaseService.signIn(email, password);
      if (mounted) {
        context.go('/chats');
        context.showSnackBar(message: 'Successfully signed in!');
      } else {
        context.showErrorSnackBar(message: 'Failed to sign in!');
      }
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
      //TODO: fix better error messages
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
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
                controller: _passwordController,
                label: 'Password',
                validator: (String? value) {
                  if (value!.isEmpty || value.length < 7) {
                    return 'Password must be at least 7 characters long';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signIn();
                  }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.go('/sign-up');
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'create_event.dart';
import 'main.dart';

void main() {
  runApp(LoginViewApp());
}

class LoginViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSignUp = false; // Determines if the sign-up form should be shown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    showSignUp = index == 1;
                  });
                },
                isSelected: [!showSignUp, showSignUp],
                color: Colors.black,
                selectedColor: Colors.white,
                fillColor: Colors.brown,
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Log In', style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Sign Up', style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: showSignUp ? signUpForm(context) : loginForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
          validator: (value) => value != null && value.contains('@') ? null : 'Please enter a valid email',
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          validator: (value) => value != null && value.length >= 6 ? null : 'Password must be at least 6 characters',
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              try {
                await _auth.signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainApp()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login failed: ${e.toString()}'), backgroundColor: Colors.red),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget signUpForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
          validator: (value) => value != null && value.contains('@') ? null : 'Please enter a valid email',
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          validator: (value) => value != null && value.length >= 6 ? null : 'Password must be at least 6 characters',
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              try {
                await _auth.createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign up successful'), backgroundColor: Colors.green),
                );
                setState(() => showSignUp = false); // Optionally switch to login view after signing up
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign up failed: ${e.toString()}'), backgroundColor: Colors.red),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
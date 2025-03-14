import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:imtihon/uch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isObscure = true;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _saveData() {
    if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ma'lumotlar muvaffaqiyatli saqlandi!")),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              savedLogin: loginController.text,
              savedPassword: passwordController.text,
            ),
          ),
        );
      });
    }
  }

  Widget buildGlassTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _isObscure : false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black54),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ro'yxatdan o'tish",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/coin.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildGlassTextField("Familiya", lastNameController),
                SizedBox(height: 10),
                buildGlassTextField("Ism", firstNameController),
                SizedBox(height: 10),
                buildGlassTextField("Login", loginController),
                SizedBox(height: 10),
                buildGlassTextField("Parol", passwordController,
                    isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text("Saqlash"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final String savedLogin;
  final String savedPassword;

  const LoginScreen(
      {Key? key, required this.savedLogin, required this.savedPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController =
        TextEditingController(text: savedLogin);
    final TextEditingController passwordController =
        TextEditingController(text: savedPassword);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                glassTextField("Login", loginController, false),
                SizedBox(height: 10),
                glassTextField("Parol", passwordController, true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (loginController.text == savedLogin &&
                        passwordController.text == savedPassword) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => uch()));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Kirish"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget glassTextField(
      String hint, TextEditingController controller, bool isPassword) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}

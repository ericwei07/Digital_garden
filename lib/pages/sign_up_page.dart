import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'log_in_page.dart';
import '../main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _signUp = TextEditingController();
  final _signUpPassword = TextEditingController();
  final _signUpMail = TextEditingController();

  final Dio dio = Dio();

  Future<void> request(name, mail, password) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    Response response;
    response = await dio.post('/account/signup', data: {'username': name, 'email': mail, 'password': password});
    if (response.data['result'] == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('user already exists'),
        ),
      );
    } else if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('email address is used'),
        ),
      );
    } else if (response.data['result'] == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('email address and/or user name field is empty'),
        ),
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      var token = response.data['token'];
      await prefs.setString('baseUrl', AppConfig.baseUrl);
      await prefs.setString('accessToken', token);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(
            title: 'digital garden',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  validEmail(String mail) {
    if (mail.isEmpty) {
      return false;
    }
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+(?:\.[a-zA-Z0-9-]+)*$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(mail);
  }

  void _checkInput() async {
    if (_signUp.text.isEmpty || _signUpPassword.text.isEmpty || !validEmail(_signUpMail.text)) {
      var emptyField = '';
      if (_signUp.text.isEmpty) {
        emptyField += 'Username';
      }
      if (_signUpPassword.text.isEmpty) {
        if (emptyField != '') {
          emptyField += ' and ';
        }
        emptyField += 'Password';
      }
      if (emptyField.isNotEmpty) {
        emptyField += ' can not be empty';
      }

      if (!validEmail(_signUpMail.text)) {
        if (emptyField != '') {
          emptyField += ' and ';
        }
        emptyField += 'Email address is invalid';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emptyField),
        ),
      );
    } else {
      await request(_signUp.text, _signUpMail.text, _signUpPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _signUpMail,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email address', hintText: 'Enter your Email here'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _signUp,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Username', hintText: 'Enter your username here'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _signUpPassword,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password', hintText: 'Enter your Password here'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(onPressed: _checkInput, child: const Text("Sign up")),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already have an account? click"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) {
                          return const LogInPage(title: 'Log in');
                        }
                      ),
                    );
                  },
                  child: const Text('Here'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

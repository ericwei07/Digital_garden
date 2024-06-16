import 'package:flutter/material.dart';


import 'main.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});
  final String title;


  @override
  State<SignUpPage> createState() => _SignUpPage();
}


class _SignUpPage extends State<SignUpPage> {
  final _signUp = TextEditingController();
  final _signUpPassword = TextEditingController();


  void _checkInput() {
    if (_signUp.text.isEmpty || _signUpPassword.text.isEmpty) {
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
      emptyField += ' can not be empty';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emptyField),
        ),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const MainPage(title: 'digital garden',)),
            (Route<dynamic> route) => false,
      );
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
                const Text("Username:"),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _signUp,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter your username here'),
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
                const Text("Password:"),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _signUpPassword,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Password'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: _checkInput, child: const Text("Sign up")),
          ],
        ),
      ),
    );
  }
}


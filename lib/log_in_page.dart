import 'package:flutter/material.dart';
import 'package:happy_digital_garden/sign_up_page.dart';
import 'main.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key, required this.title});
  final String title;


  @override
  State<LogInPage> createState() => _LogInPage();
}


class _LogInPage extends State<LogInPage> {
  final _logIn = TextEditingController();
  final _logInPassword = TextEditingController();

  void _checkInput() {
    if (_logIn.text.isEmpty || _logInPassword.text.isEmpty) {
      var emptyField = '';
      if (_logIn.text.isEmpty) {
        emptyField += 'Username';
      }
      if (_logInPassword.text.isEmpty) {
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
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _logIn,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Username'),
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
                    controller: _logInPassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Password',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(onPressed: _checkInput, child: const Text("Log in")),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account? click"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {return const SignUpPage(title: 'Sign Up');}));
                    },
                    child: const Text('Here')
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


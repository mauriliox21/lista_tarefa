import 'package:flutter/material.dart';
import 'package:lista_tarefa/calendar.dart';

String email = "";
String senha = "";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(width: 70, height: 70),
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(width: 30, height: 30),
            Padding(
              padding: EdgeInsets.all(22.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (text) {
                      email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (text) {
                      senha = text;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
                    ),
                    child: Text(
                      'LOGAR', 
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      if (email == 'maurilio@gmail' && senha == '123') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalendarPage(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Login incorreto'),
                              content: Text(
                                'Tente novamente com login e senha corretos',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Fechar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

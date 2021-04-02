import 'package:flutter/material.dart';

void main(){
  runApp(Passwords());
}

class Passwords extends StatefulWidget {

  @override
  _PasswordsState createState() => _PasswordsState();

}

class _PasswordsState extends State<Passwords>{

  @override
  Widget build(BuildContext context){

    return Scaffold(

        body: Column(

          children: [

            Text("IServ Login"),

            TextField(

              decoration: InputDecoration(

                hintText: "IServ - Benutzername",

              ),

            ),

            TextField(

              decoration: InputDecoration(

                hintText: "IServ - Passwort",

              ),

            ),

            Divider(),

            Text("DSB Login"),

            TextField(

              decoration: InputDecoration(

                hintText: "DSB - Kennung",

              ),

            ),

            TextField(

              decoration: InputDecoration(

                hintText: "DSB - Passwort",

              ),

            ),

          ],

        )

    );

  }

}

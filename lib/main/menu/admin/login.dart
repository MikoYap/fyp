import 'package:flutter/material.dart';
import 'package:fyp/main/menu/admin/admin.dart';
import 'package:fyp/main/auth/auth.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color.fromRGBO(7, 113, 9, 1), Color.fromRGBO(199, 248, 0, 1)]),
          ),
        ),
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Enter admin email
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                validator: (val) => val!.isEmpty ? "Enter an email" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),

              // Enter admin password
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                ),
                obscureText: true,
                validator: (val) => val!.length <= 0 ? "Enter a password" : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),

              SizedBox(
                height: 20,
              ),

              ElevatedButton(
                child: Text("Login"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.loginWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = "Email or password is invalid");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Admin())
                      );
                    }
                  }
                },
              ),

              SizedBox(
                height: 12,
              ),

              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

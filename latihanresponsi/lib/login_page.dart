import 'package:flutter/material.dart';
import 'package:latihanresponsi/restaurant_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  Icon icon = Icon(Icons.visibility);

  bool obscure = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("is_logged_in") ?? false;
    if (!mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RestaurantMenu()),
      );
    }
  }

  Future<void> _loginBtn() async {
    if (_formkey.currentState!.validate()) {
      if (_username.text.trim() == "rijal" &&
          _password.text.trim() == "rijal") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("is_logged_in", true);
        await prefs.setString("Username", _username.text.trim());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Berhasil"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RestaurantMenu()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Username atau Password Salah"),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Latihan Responsi Restoran",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Text(
                  "Afrizal Ardhi",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "123220128",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 20),
                //Username
                TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Username tidak boleh kosong!'
                      : null,
                  controller: _username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 15),
                //Password
                TextFormField(
                  controller: _password,
                  validator: (value) => value == null || value.isEmpty
                      ? 'password ga boleh kosong'
                      : null,
                  obscureText: obscure,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (obscure == true) {
                              obscure = false;
                              icon = Icon(Icons.visibility_off);
                            } else {
                              obscure = true;
                              icon = Icon(Icons.visibility);
                            }
                          });
                        },
                        color: Colors.white,
                        icon: icon),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: _loginBtn,
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

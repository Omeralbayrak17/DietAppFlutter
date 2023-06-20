import 'package:diet_app/Services/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerHeight = TextEditingController();
  final TextEditingController _controllerWeight = TextEditingController();

  bool _isSecure = true;
  bool _isConfirmSecure = true;
  String? errorMessage = " ";
  final formKey = GlobalKey<FormState>();


  //Kullanıcının boyunu girmesi için açılan textbox. İçinde doğrulama yapılır.

  Widget _heightEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your height";
          } else if (value.length > 3 && value.length <= 1) {
            return "Your height is invalid";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.height),
            suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
            hintText: title,
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)),
            errorStyle: const TextStyle(
                backgroundColor: Colors.transparent, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  //Kullanıcının kilosunu girmesi için açılan textbox. İçinde doğrulama yapılır.

  Widget _weightEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your weight";
          } else if (value.length > 4 && value.length <= 1) {
            return "Your weight is invalid";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.monitor_weight_outlined),
            suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
            hintText: title,
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)),
            errorStyle: const TextStyle(
                backgroundColor: Colors.transparent, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  //Kullanıcının ismini girmesi için açılan textbox. İçinde doğrulama yapılır.

  Widget _nameEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your name";
          } else if (value.length < 2) {
            return "Your name can't be shorter than 2 letters";
          } else if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ]+$').hasMatch(value)) {
            return "Please enter an alphabetical name";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.person),
            suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
            hintText: title,
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)),
            errorStyle: const TextStyle(
                backgroundColor: Colors.transparent, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  //Kullanıcının emailini girmesi için açılan textbox. İçinde doğrulama yapılır.

  Widget _emailEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your e-mail";
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value)) {
            return "Please enter a valid e-mail";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.mail),
            suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
            hintText: title,
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)),
            errorStyle: const TextStyle(
                backgroundColor: Colors.transparent, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  //Kullanıcının şifresini girmesi için açılan textbox. Eğer boş girildi ise doğrulama yapılır.

  Widget _passwordEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your password";
          }
        },
        controller: controller,
        obscureText: _isSecure,
        decoration: InputDecoration(
            suffixIcon: togglePassword(),
            suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
            hintText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white.withOpacity(0.7),
            filled: true,
            errorStyle: const TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  //Kullanıcının şifresini görmesi için açılan iconbutton.

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecure = !_isSecure;
          });
        },
        icon: _isSecure
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off));
  }

  //Kullanıcının şifresini görmesi için açılan iconbutton.

  Widget toggleConfirmPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isConfirmSecure = !_isConfirmSecure;
          });
        },
        icon: _isConfirmSecure
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off));
  }

  //Kullanıcının şifresinin doğru olduğuna bakmak için açılan textbox. İçinde ilk girilen şifre ile kendisinin doğrulamasını yapar.

  Widget _confirmPasswordEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your password again";
          }
        },
        controller: controller,
        obscureText: _isConfirmSecure,
        decoration: InputDecoration(
            suffixIcon: toggleConfirmPassword(),
            suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
            hintText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white.withOpacity(0.7),
            filled: true,
            errorStyle: const TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  //Kullanıcılar kayıt ol butonuna basınca çalışacak buton. Kullanıcıyı firebase'a kayıt eder.

  Widget _submitButton() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 137, 49, 1.0)),
                onPressed: () async {
                  if (_controllerPassword.text == _controllerConfirmPassword.text) {
                    if (formKey.currentState!.validate()) {
                      try {
                        UserCredential authResult = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _controllerEmail.text,
                                password: _controllerPassword.text);
                        String uid = authResult.user!.uid;
                        String userHeight = _controllerHeight.text;
                        String userWeight = _controllerWeight.text;
                        double height = double.parse(userHeight) / 100.0;
                        int weight = int.parse(userWeight);
                        int bmi = weight ~/ (height * height);
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .set({
                          'name': _controllerName.text,
                          'email': _controllerEmail.text,
                          'height': height,
                          'weight': weight,
                          'bmi': bmi,
                          'currentDiet': "null",
                          'weight_history': [weight],
                          'createdAt': FieldValue.serverTimestamp(),
                        }).then((value) => Navigator.pop(context));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          setState(() {
                            errorMessage = "Your password must be longer than 6 letters.";
                          });
                        } else if (e.code == 'email-already-in-use') {
                          setState(() {
                            errorMessage = "The e-mail is already in use";
                          });
                        } else {
                          setState(() {
                            errorMessage = "A problem occurred";
                          });
                        }
                      }
                    }
                  }
                  else {
                    setState(() {
                      errorMessage = "Your password does not match";
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 22),
                  ),
                ))),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: const AssetImage('lib/images/register.gif'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.45), BlendMode.darken))),
        child: SafeArea(
          child: Center(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dietApp(),
                  const Text(
                    "Welcome To Diet App!",
                    style: TextStyle(
                        fontSize: 32, color: Color.fromRGBO(237, 174, 73, 1)),
                  ),
                  const Text(
                      "Register with your e-mail and start using Diet App.",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _nameEntryField("Name", _controllerName),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _heightEntryField("Height", _controllerHeight),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _weightEntryField("Weight", _controllerWeight),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _emailEntryField("E-mail", _controllerEmail),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _passwordEntryField("Password", _controllerPassword),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _confirmPasswordEntryField(
                            "Confirm Password", _controllerConfirmPassword),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _submitButton(),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(errorMessage!, style: TextStyle(color: Colors.white, fontSize: 18),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}

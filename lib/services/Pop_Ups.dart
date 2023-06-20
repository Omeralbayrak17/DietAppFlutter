
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

final user = FirebaseAuth.instance.currentUser;

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore _db = FirebaseFirestore.instance;

final CollectionReference _usersRef = _db.collection('users');

void updateUserData(String uid, String newValue) async {
  await _usersRef.doc(uid).update({
    'name': newValue,
  });
  return;
}

void updateUserHeight(String uid, double newValue, int bmi) async {
  await _usersRef.doc(uid).update({
    'height': newValue,
    'bmi': bmi,
  });
  return;
}

void updateUserWeight(String uid, int newValue, int bmi) async {

  DocumentReference documentRef = FirebaseFirestore.instance.collection('users').doc(uid);
  DocumentSnapshot documentSnapshot = await documentRef.get();

  if (documentSnapshot.exists) {
    List<dynamic> arrayData = documentSnapshot.get('weight_history') ?? [];

    arrayData.add(newValue);

    await documentRef.update({'weight_history': arrayData});
  }

  await _usersRef.doc(uid).update({
    'weight': newValue,
    'bmi': bmi,
  });
}


class ChangeNamePopUp extends StatefulWidget {
  const ChangeNamePopUp({Key? key}) : super(key: key);

  @override
  State<ChangeNamePopUp> createState() => _ChangeNamePopUpState();
}

class _ChangeNamePopUpState extends State<ChangeNamePopUp> {

  final _nameController = TextEditingController();
  final _popUpFormKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleMedium("Change Your Name"),
      content: SingleChildScrollView(
        child: Form(
          key: _popUpFormKey,
          child: TextFormField(
            controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your name";
                } else if (value.length < 2) {
                  return "Your name is too short";
                } else if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ]+$').hasMatch(value)) {
                  return "Please enter an alphabetical name";
                }
              },
            decoration: InputDecoration(
                suffixIcon: const Icon(Icons.person),
                suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
                hintText: "Enter your name",
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                errorStyle: const TextStyle(
                    backgroundColor: Colors.transparent, color: Colors.red),
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
        ),
      ),
      actions: [
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("Cancel", style: TextStyle(color: getOrange()),)),
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: () {
          User? user = _auth.currentUser;
          if(_popUpFormKey.currentState!.validate()){
            try {
              if (user != null) {
                String uid = user.uid;
                updateUserData(uid, _nameController.text);
                Navigator.of(context).pop();
                Flushbar(
                  animationDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 3),
                  title: "DietApp",
                  message: "Your name changed successfully",
                  forwardAnimationCurve: Curves.bounceInOut,
                  reverseAnimationCurve: Curves.bounceOut,
                  backgroundColor: getLila(),
                  margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                  borderRadius: BorderRadius.circular(8),
                  backgroundGradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: getOrange().withOpacity(0.5),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ).show(context);
              }
            } catch (e) {
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "An error accurred.",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(context);
            }
          }

        }, child: Text("OK", style: TextStyle(color: getOrange()),))
      ],
    );
  }
}

class ChangeEmailPopUp extends StatefulWidget {
  const ChangeEmailPopUp({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPopUp> createState() => _ChangeEmailPopUpState();
}

class _ChangeEmailPopUpState extends State<ChangeEmailPopUp> {

  final _emailController = TextEditingController();
  final _popUpFormKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {

    //Bir alertdialog oluşturma kodu
    return AlertDialog(
      title: titleMedium("Change Your E-mail"), //Alertdialog başlığı
      content: SingleChildScrollView(
        child: Form(
          key: _popUpFormKey,
          child: TextFormField( //Textformfield sayesinde bir textbox açıldı
            controller: _emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter your e-mail";
              } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return "Please enter a valid e-mail";
              }
            },
            decoration: InputDecoration( //Inputdecoration ile bir icon oluşturuldu
                suffixIcon: const Icon(Icons.mail_outline),
                suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
                hintText: "Enter your e-mail",
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                errorStyle: const TextStyle(
                    backgroundColor: Colors.transparent, color: Colors.red),
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
        ),
      ),
      actions: [ //Pop-upta bulunan aksiyonlar (butonlar)
        //Hayır butonu (pop-upu kapatmaya yarar)
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("Cancel", style: TextStyle(color: getOrange()),)),
        //Evet butonu, basıldığı zaman kullanıcının e-postasını değiştirmek için bir try-catch gönderir ve eğer trydaki kod bloğu doğru şekilde çalışırsa firebase ile iletişime geçilir ve kullanıcının e-postası değişir
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: () async {
          User? user = _auth.currentUser;
          if(_popUpFormKey.currentState!.validate()){
            try {
              await user?.updateEmail(_emailController.text);
              Navigator.of(this.context).pop();
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "Your e-mail is changed successfully",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(this.context); //Burada ise kullanıcıya bir flushbar paketi sayesinde güzel bir tasarıma sahip flushbar gösterilir
            } on FirebaseAuthException catch (error) {
              if (error.code == 'email-already-in-use') {
                Flushbar(
                  animationDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 3),
                  title: "DietApp",
                  message: "This e-mail is already in use.",
                  forwardAnimationCurve: Curves.bounceInOut,
                  reverseAnimationCurve: Curves.bounceOut,
                  backgroundColor: getLila(),
                  margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                  borderRadius: BorderRadius.circular(8),
                  backgroundGradient: LinearGradient(
                    colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: getOrange().withOpacity(0.5),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ).show(this.context);
              }
              else if (error.code == 'requires-recent-login'){

                Flushbar(
                  animationDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 3),
                  title: "DietApp",
                  message: "Please log in again before you change e-mail",
                  forwardAnimationCurve: Curves.bounceInOut,
                  reverseAnimationCurve: Curves.bounceOut,
                  backgroundColor: getLila(),
                  margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                  borderRadius: BorderRadius.circular(8),
                  backgroundGradient: LinearGradient(
                    colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: getOrange().withOpacity(0.5),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ).show(this.context); //Hata geldiği anda ise hata mesajı flushbar ile gösterilir
              }
            } catch (error) {
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "An error accurred",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(this.context);
            }

          }
        }, child: Text("OK", style: TextStyle(color: getOrange()),))
      ],
    );
  }
}

class ChangePasswordPopUp extends StatefulWidget {
  const ChangePasswordPopUp({Key? key}) : super(key: key);



  @override
  State<ChangePasswordPopUp> createState() => _ChangePasswordPopUpState();
}

class _ChangePasswordPopUpState extends State<ChangePasswordPopUp> {


  final _passwordController = TextEditingController();
  final _popUpFormKey = GlobalKey<FormState>();
  bool _isSecure = true;

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

  @override


  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleMedium("Change Your Password"),
      content: SingleChildScrollView(
        child: Form(
          key: _popUpFormKey,
          child: TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter your password";
              } else if (value.length < 6) {
                return "Please enter a longer password";
              }
            },
            obscureText: _isSecure,
            decoration: InputDecoration(
                suffixIcon: togglePassword(),
                suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
                hintText: "Enter your password",
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                errorStyle: const TextStyle(
                    backgroundColor: Colors.transparent, color: Colors.red),
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
        ),
      ),
      actions: [
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("Cancel", style: TextStyle(color: getOrange()),)),
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: () async {
          User? user = _auth.currentUser;
          if(_popUpFormKey.currentState!.validate()){
            try {
              await user?.updatePassword(_passwordController.text);
              Navigator.of(this.context).pop();
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "Your password is changed successfully",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(this.context);
            } on FirebaseAuthException catch (error) {
              print(error);
              if (error.code == 'requires-recent-login') {
                Flushbar(
                  animationDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 3),
                  title: "DietApp",
                  message: "You need to log in again to change your password.",
                  forwardAnimationCurve: Curves.bounceInOut,
                  reverseAnimationCurve: Curves.bounceOut,
                  backgroundColor: getLila(),
                  margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                  borderRadius: BorderRadius.circular(8),
                  backgroundGradient: LinearGradient(
                    colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: getOrange().withOpacity(0.5),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ).show(this.context);
              }
            } catch (error) {
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "An error occurred",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(this.context);
            }

          }
        }, child: Text("OK", style: TextStyle(color: getOrange()),))
      ],
    );
  }
}

class ChangeHeightPopUp extends StatefulWidget {
  const ChangeHeightPopUp({Key? key}) : super(key: key);

  @override
  State<ChangeHeightPopUp> createState() => _ChangeHeightPopUpState();
}

class _ChangeHeightPopUpState extends State<ChangeHeightPopUp> {
  final _heightController = TextEditingController();
  final _popUpFormKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleMedium("Change Your Height"),
      content: SingleChildScrollView(
        child: Form(
          key: _popUpFormKey,
          child: TextFormField(
            controller: _heightController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter your height";
              } else if (value.length <= 1 && value.length >= 240) {
                return "Your height is invalid";
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return "Please enter a numeric height";
              }
            },
            decoration: InputDecoration(
                suffixIcon: const Icon(Icons.height),
                suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
                hintText: "Enter your height",
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                errorStyle: const TextStyle(
                    backgroundColor: Colors.transparent, color: Colors.red),
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
        ),
      ),
      actions: [
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("Cancel", style: TextStyle(color: getOrange()),)),
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: () async {
          User? user = _auth.currentUser;
          if(_popUpFormKey.currentState!.validate()){
            try {
              if (user != null) {
                String uid = user.uid;
                double height = double.parse(_heightController.text);
                height = height / 100;
                DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                int weight = await snapshot.get('weight');
                int bmi = weight ~/ (height * height);
                updateUserHeight(uid, height, bmi);
                print(bmi);
                print(height);
                print(weight);
                Navigator.of(this.context).pop();
                Flushbar(
                  animationDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 3),
                  title: "DietApp",
                  message: "Your height is changed successfully",
                  forwardAnimationCurve: Curves.bounceInOut,
                  reverseAnimationCurve: Curves.bounceOut,
                  backgroundColor: getLila(),
                  margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                  borderRadius: BorderRadius.circular(8),
                  backgroundGradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: getOrange().withOpacity(0.5),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ).show(this.context);
              }
            } catch (e) {
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "An error accurred.",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(context);
            }
          }

        }, child: Text("OK", style: TextStyle(color: getOrange()),))
      ],
    );
  }
}

class ChangeWeightPopUp extends StatefulWidget {
  const ChangeWeightPopUp({Key? key}) : super(key: key);

  @override
  State<ChangeWeightPopUp> createState() => _ChangeWeightPopUpState();
}

class _ChangeWeightPopUpState extends State<ChangeWeightPopUp> {
  final _weightController = TextEditingController();
  final _popUpFormKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleMedium("Change Your Weight"),
      content: SingleChildScrollView(
        child: Form(
          key: _popUpFormKey,
          child: TextFormField(
            controller: _weightController,
            validator: (value) {
              int userWeight = int.parse(_weightController.text);
              if (value!.isEmpty) {
                return "Please enter your weight";
              } else if (value.length <= 1 || value.length >= 4 || userWeight>200) {
                return "Please enter a real weight";
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return "Please enter a numeric height";
              }
            },
            decoration: InputDecoration(
                suffixIcon: const Icon(Icons.monitor_weight_outlined),
                suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
                hintText: "Enter your weight",
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                errorStyle: const TextStyle(
                    backgroundColor: Colors.transparent, color: Colors.red),
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
        ),
      ),
      actions: [
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("Cancel", style: TextStyle(color: getOrange()),)),
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: () async {
          User? user = _auth.currentUser;
          if(_popUpFormKey.currentState!.validate()){
            try {
              if (user != null) {
                String uid = user.uid;
                int weight = int.parse(_weightController.text);
                DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                double height = await snapshot.get('height');
                int bmi = weight ~/ (height * height);
                updateUserWeight(uid, weight, bmi);
                Navigator.of(this.context).pop();
                Flushbar(
                  animationDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 3),
                  title: "DietApp",
                  message: "Your weight is changed successfully",
                  forwardAnimationCurve: Curves.bounceInOut,
                  reverseAnimationCurve: Curves.bounceOut,
                  backgroundColor: getLila(),
                  margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                  borderRadius: BorderRadius.circular(8),
                  backgroundGradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
                  ),
                  boxShadows: [
                    BoxShadow(
                      color: getOrange().withOpacity(0.5),
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ).show(this.context);
              }
            } catch (e) {
              Flushbar(
                animationDuration: const Duration(seconds: 1),
                duration: const Duration(seconds: 3),
                title: "DietApp",
                message: "An error accurred.",
                forwardAnimationCurve: Curves.bounceInOut,
                reverseAnimationCurve: Curves.bounceOut,
                backgroundColor: getLila(),
                margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                borderRadius: BorderRadius.circular(8),
                backgroundGradient: LinearGradient(
                  colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.5)],
                ),
                boxShadows: [
                  BoxShadow(
                    color: getOrange().withOpacity(0.5),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ).show(context);
            }
          }

        }, child: Text("OK", style: TextStyle(color: getOrange()),))
      ],
    );
  }
}

class AboutUsPopUp extends StatefulWidget {
  const AboutUsPopUp({Key? key}) : super(key: key);

  @override
  State<AboutUsPopUp> createState() => _AboutUsPopUpState();
}

class _AboutUsPopUpState extends State<AboutUsPopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleMedium("Diet App"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            titleDescription("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
          ],
        ),
      ),
      actions: [
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("OK", style: TextStyle(color: getOrange()),)),
      ],
    );
  }
}

class PrivacyPolicyPopUp extends StatefulWidget {
  const PrivacyPolicyPopUp({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPopUp> createState() => _PrivacyPolicyPopUpState();
}

class _PrivacyPolicyPopUpState extends State<PrivacyPolicyPopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleMedium("Diet App"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            titleDescription("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
          ],
        ),
      ),
      actions: [
        TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))), onPressed: (){ Navigator.of(context).pop(); }, child: Text("OK", style: TextStyle(color: getOrange()),)),
      ],
    );
  }
}

flushbarSelectDiet(BuildContext context, selectedDiet){
  return Flushbar(
    duration: const Duration(seconds: 3),
    title: "DietApp",
    message: 'You selected $selectedDiet as your current diet',
    forwardAnimationCurve: Curves.bounceInOut,
    reverseAnimationCurve: Curves.bounceOut,
    backgroundColor: getLila(),
    margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
    borderRadius: BorderRadius.circular(8),
    backgroundGradient: LinearGradient(
      colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
    ),
    boxShadows: [
      BoxShadow(
        color: getOrange().withOpacity(0.5),
        offset: const Offset(0.0, 2.0),
        blurRadius: 3.0,
      ),
    ],
  ).show(context);
}

flushbarUnselectDiet(BuildContext context, selectedDiet){
  return Flushbar(
    animationDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 3),
    title: "DietApp",
    message: 'You unselected $selectedDiet',
    forwardAnimationCurve: Curves.bounceInOut,
    reverseAnimationCurve: Curves.bounceOut,
    backgroundColor: getLila(),
    margin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
    borderRadius: BorderRadius.circular(8),
    backgroundGradient: LinearGradient(
      colors: [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.5)],
    ),
    boxShadows: [
      BoxShadow(
        color: getOrange().withOpacity(0.5),
        offset: const Offset(0.0, 2.0),
        blurRadius: 3.0,
      ),
    ],
  ).show(context);
}
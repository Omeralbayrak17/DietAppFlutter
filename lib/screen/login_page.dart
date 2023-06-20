import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isSecure = true;
  String? errorMessage = '';
  final formKey = GlobalKey<FormState>();

  //Burada email girilmesi için bir textbox açılmıştır ve validator özelliği ile girilen verinin email olduğu doğrulanmıştır.

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

  //Burada şifre girilmesi için bir textbox açılmıştır, password olması için obscure text kullanılmıştır ve boş olup olmadığını kontrol etmek için validator kullanılmıştır. Ayrıca textboxun sonuna bir göz ikonu koyulmuştur bu sayede kullanıcılar şifrelerini doğrulamak için görebilirler.

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

  //Kullanıcıların şifrelerini görebilmeleri için gereken işlemleri yapan fonksiyon. Basıldığı zaman tersini yaparak eğer şifre gözüküyorsa gizliyor, gizliyse gösteriyor.

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

  //Bu textbutton sayesinde kullanıcılar şifrelerini unuttular ise onlara bir email göndermek için alertdialog açılır ve alert dialogdaki eposta alanı doldurularak kullanıcılara bir email gönderme işlemi yapar.

  Widget _forgotPasswordButton() {

    TextEditingController _forgotPasswordEmailController = TextEditingController();

    final resetPasswordKey = GlobalKey<FormState>();

    return TextButton(
        style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.2)),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Forgot Password"),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.23,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: [
                        const Text("Enter your e-mail and we will send you a password reset link"),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
                        Form(
                          key: resetPasswordKey,
                          child: TextFormField(
                            controller: _forgotPasswordEmailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Your e-mail information is empty";
                              } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return "Please enter a valid e-mail";
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.mail),
                                suffixIconColor: const Color.fromRGBO(147, 129, 255, 1),
                                hintText: "Enter your E-mail",
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      ],
                    )
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel', style: TextStyle(color: Color.fromRGBO(237, 174, 73, 1)),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Send Reset Link', style: TextStyle(color: Color.fromRGBO(147, 129, 255, 1)),),
                      onPressed: () async {
                        if (resetPasswordKey.currentState!.validate()){
                          try{
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: _forgotPasswordEmailController.text);
                            final snackBar = SnackBar(content: const Text("We have sent you a password reset link", style: TextStyle(color: Colors.white),), duration: Duration(seconds: 5), backgroundColor: Colors.black.withOpacity(0.7),);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (error){
                            if (error.code == 'user-not-found'){
                              final snackBar = SnackBar(content: const Text("This e-mail does not have an account", style: TextStyle(color: Colors.white),), duration: Duration(seconds: 5), backgroundColor: Colors.black.withOpacity(0.7),);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              Navigator.pop(context);
                            }
                          }

                        }
                      },
                    )
                  ],
                );
              });
        },
        child: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  //Bu button kullanıcılar işlemlerini tamamladığı zaman basıldığında çalışır. Kullanıcıların verdiği verileri firebaseAuth ile karşılaştırır ve bu sayede giriş yaptırır veya hata verir.

  Widget _submitButton() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(147, 129, 255, 1)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _controllerEmail.text,
                              password: _controllerPassword.text)
                          .then((value) => Navigator.pop(context));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-disabled'){
                        setState(() {
                          errorMessage = "Your account is suspended";
                        });
                      }
                      else if (e.code == 'user-not-found'){
                        setState(() {
                          errorMessage = "Your e-mail does not have an account";
                        });
                      }
                      else if (e.code == 'wrong-password'){
                        setState(() {
                          errorMessage = "Your password is wrong";
                        });
                      }
                      else {
                        setState(() {
                          errorMessage = "A problem occurred";
                        });
                      }
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    "Log in",
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
          "Log in",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration( //Backgrounda olan gif'i çalıştırmak için yazılan kod.
            image: DecorationImage(
                image: const AssetImage('lib/images/background.gif'),
                fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken))),
        child: SafeArea(
          child: Center(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                      fontSize: 32, color: Color.fromRGBO(237, 174, 73, 1)),
                ),
                const Text(
                    "Enter your e-mail and password to login your account.",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: height * 0.03,
                ),
                Form( // Buradaki formkey sayesinde kullanıcıların girdiği verilerin doğruluğu hesaplanır ve kullanıcı hatalı bilgi girdiği zaman girilen textboxun altında bir hata mesajı belirir.
                  key: formKey,
                  child: Column(children: [
                    _emailEntryField("E-mail", _controllerEmail),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    _passwordEntryField("Password", _controllerPassword),
                    _forgotPasswordButton(),
                    _submitButton()
                  ]),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(errorMessage!, style: const TextStyle(color: Colors.white, fontSize: 18),) //Buradaki error message ilk başta boş gözükür. Eğer bir hata gelirse stateful widget kullanıldığı için state'i değişir ve kullanıcılara bir hata mesajı gözükür.
              ],
            ),
          )),
        ),
      ),
    );
  }
}
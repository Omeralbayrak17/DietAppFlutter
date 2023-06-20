import 'package:diet_app/screen/login_page.dart';
import 'package:diet_app/screen/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/Services/Widgets.dart';

class ChooseAuthScreen extends StatefulWidget {
  const ChooseAuthScreen({Key? key}) : super(key: key);

  @override
  State<ChooseAuthScreen> createState() => _ChooseAuthScreenState();
}


class _ChooseAuthScreenState extends State<ChooseAuthScreen> {
  @override

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;


    // Login widgeti ile kullanıcıya bir buton gösteriyoruz ekranda. Bu butona tıklandığı zaman kullanıcıyı giriş yapma menüsüne gönderiyoruz

    Widget loginButton(){
      return ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(147, 129, 255, 1)
        ),
        child: Container(
          height: height * 0.075,
          width: width * 0.8,
          child: const Align(alignment: Alignment.center, child: Text("Log in", style: TextStyle(fontSize: 26, color: Colors.white),)),
        ),
      );
    }

    //Register butonu'na tıklandığı zaman kullanıcıyı register ekranına götürmek için navigator.push kullanılmıştır. Login butonu ile aynı kodlara sahiptir. Java veKotlindeki intent işlevinin benzeridir

    Widget registerButton(){
      return ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 137, 49, 1.0),
        ),
        child: Container(
          height: height * 0.075,
          width: width * 0.8,
          child: const Align(alignment: Alignment.center, child: Text("Register", style: TextStyle(fontSize: 26, color: Colors.white),)),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('lib/images/background.gif'),
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
              fit: BoxFit.cover,
            )),
        child: Column(
          children: [
            SizedBox(height: height * 0.1,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  dietAppLogo(),
                ],
              ),
            ),
            SizedBox(height: height * 0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginButton(),
              ],
            ),
            SizedBox(height: height * 0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                registerButton(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

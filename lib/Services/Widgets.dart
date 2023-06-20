import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/login_page.dart';

Widget dietAppLogo() {
  return Container(
    height: 300,
    width: 400,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/images/dietapp.png'))),
  );
}

Widget dietApp() {
  return Container(
    height: 200,
    width: 300,
    decoration: const BoxDecoration(
        image:
            DecorationImage(image: AssetImage('lib/images/dietapplogo.png'))),
  );
}

Color getLila() {
  return const Color.fromRGBO(147, 129, 255, 1);
}

Color getOrange(){
  return const Color.fromRGBO(255, 137, 49, 1.0);
}

Text textHeadline(String text, String text2) {
  return Text.rich(TextSpan(children: [
    TextSpan(
        text: text,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.w400, fontSize: 26)),
    TextSpan(
        text: text2,
        style: GoogleFonts.ptSans(
            fontWeight: FontWeight.w400,
            fontSize: 26,
            color: const Color.fromRGBO(0, 0, 0, 1.0))),
  ]));
}

Text titleMedium(String text) {
  return Text.rich(TextSpan(children: [
    TextSpan(
        text: text,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.w300, fontSize: 28)),
  ]));
}

Text titleSmall(String text) {
  return Text.rich(TextSpan(children: [
    TextSpan(
        text: text,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.w300, fontSize: 24)),
  ]));
}

Text titleDescription(String text) {
  return Text(
    text,
    style: GoogleFonts.ptSans(
        fontSize: 14, color: const Color.fromRGBO(0, 123, 167, 1.0)),
  );
}

Text dietInformationText(String text, BuildContext context) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: GoogleFonts.ptSans(
        fontSize: MediaQuery.of(context).size.height * 0.022,
        color: const Color.fromRGBO(0, 0, 0, 1.0)),
  );
}

Text dietInformationText2(String text, BuildContext context) {
  return Text(
    text,
    textAlign: TextAlign.right,
    style: GoogleFonts.ptSans(
        fontWeight: FontWeight.w400,
        fontSize: MediaQuery.of(context).size.height * 0.022,
        color: const Color.fromRGBO(0, 0, 0, 1.0)),
  );
}

Text dietInformationDatabaseText(int text, BuildContext context, String short) {
  return Text(
    "$text $short",
    textAlign: TextAlign.right,
    style: GoogleFonts.ptSans(
        fontWeight: FontWeight.w400,
        fontSize: MediaQuery.of(context).size.height * 0.022,
        color: const Color.fromRGBO(0, 0, 0, 1.0)),
  );
}

TextButton settingsPageTextButton(
    BuildContext context, String text, IconData icon, Widget myClassname) {
  return TextButton(
    onPressed: () {
      showDialog(context: context, builder: (BuildContext context){
        return myClassname;
      });
    },
    style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.015,
              horizontal: 0),
        ),
        overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.2))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: GoogleFonts.ptSans(
                color: Colors.black54,
                fontSize: MediaQuery.of(context).size.height * 0.021)),
        Icon(
          icon,
          color: Colors.black54,
          size: MediaQuery.of(context).size.height * 0.027,
        )
      ],
    ),
  );
}

Text settingsPageSubTitle(BuildContext context, String text) {
  return Text(
    text,
    style: GoogleFonts.ptSans(
        fontSize: MediaQuery.of(context).size.height * 0.027),
  );
}

TextButton settingPageLogoutText(BuildContext context) {
  return TextButton(
      onPressed: () {

      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015,),
        ),
        overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.3))
      ),
      child: Text("Logout", style: GoogleFonts.ptSans(color: Colors.black, fontSize: MediaQuery.of(context).size.height * 0.025,)));
}

TextButton settingsPageLogoutButton(BuildContext context, String text, IconData icon) {
  return TextButton(
    onPressed: () {
      FirebaseAuth.instance.signOut();
    },
    style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
              vertical: MediaQuery
                  .of(context)
                  .size
                  .height * 0.015, horizontal: 0),
        ),
        overlayColor: MaterialStateProperty.all(getLila().withOpacity(0.2))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: GoogleFonts.ptSans(
                color: Colors.black54,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .height * 0.021)),
        Icon(
          icon,
          color: Colors.black54,
          size: MediaQuery
              .of(context)
              .size
              .height * 0.027,
        )
      ],
    ),
  );
}

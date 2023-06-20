import 'package:another_flushbar/flushbar.dart';
import 'package:diet_app/Services/Pop_Ups.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {

  String scanResult = "";

  //Bir scanbarcode fonksiyonu ile kullanıcı textbuttona tıkladığı anda kullanıcıyı flutter_barcode_scanner paketi ile barkod okutma ekranına gönderiyoruz ve barkodu okutup kullanıcıya veriyi geri döndürüyoruz
  Future scanBarcode() async{
    String scanResult = "";
    try{
      scanResult = await FlutterBarcodeScanner.scanBarcode("#aabbcc", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException{
      scanResult = "Failed to scan barcode."; //Bir platform hatası gelmesinde yazılacak sonuç.
    }
    setState(() {
      this.scanResult = scanResult; //Sonuç geldiğinde textbox’a scanresult sonucunu döndürecek kod
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleMedium("Settings"), //Settings textini oluşturan widget.
            const Divider(thickness: 1,),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                settingsPageSubTitle(context, "Account Settings"),
                Icon(Icons.security_outlined, size: MediaQuery.of(context).size.height * 0.03,)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            settingsPageTextButton(context, "Change your name", Icons.chevron_right, const ChangeNamePopUp()), //isim değiştirmek için kullanılan fonksiyon
            settingsPageTextButton(context, "Change your e-mail", Icons.chevron_right, const ChangeEmailPopUp()), //email değiştirmek için kullanılan fonksiyon
            settingsPageTextButton(context, "Change your password", Icons.chevron_right, const ChangePasswordPopUp()), //şifre değiştirmek için kullanılan fonksiyon
            const Divider(thickness: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                settingsPageSubTitle(context, "Personal Settings"),
                Icon(Icons.account_circle_outlined, size: MediaQuery.of(context).size.height * 0.03,)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            settingsPageTextButton(context, "Change your height", Icons.chevron_right, const ChangeHeightPopUp()), //boy değiştirmek için kullanılan fonksiyon
            settingsPageTextButton(context, "Change your weight", Icons.chevron_right, const ChangeWeightPopUp()), //kilo değiştirmek için kullanılan fonksiyon
            const Divider(thickness: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                settingsPageSubTitle(context, "More"),
                Icon(Icons.question_mark_outlined, size: MediaQuery.of(context).size.height * 0.03,)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            settingsPageTextButton(context, "About Us", Icons.chevron_right, const AboutUsPopUp()), //Hakkımızda'yı açmak için kullanılan fonksiyon
            settingsPageTextButton(context, "Privacy Policy", Icons.chevron_right, const PrivacyPolicyPopUp()), //Gizlilik politikasını açmak için kullanılan fonksiyon
            TextButton(
              onPressed: () {
                scanBarcode();
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
                  Text(scanResult == "" && scanResult == -1
                      ? 'Scan your food barcode'
                      : 'Scan result: $scanResult',
                      style: GoogleFonts.ptSans(
                          color: Colors.black54,
                          fontSize: MediaQuery.of(context).size.height * 0.021)),
                  Icon(
                    Icons.qr_code_2_outlined,
                    color: Colors.black54,
                    size: MediaQuery.of(context).size.height * 0.027,
                  )
                ],
              ),
            ),  //Barkod okuyucuyu açmak için kullanılan textbutton
            const Divider(thickness: 1,),
            settingsPageLogoutButton(context, "Logout", Icons.logout)  //Çıkış yapmak için kullanılan textbutton
          ],
        ),
      ),
    );
  }
}

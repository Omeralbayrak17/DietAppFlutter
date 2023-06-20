import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Services/Pop_Ups.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:diet_app/screen/diet_day_information_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class DietInformationPage extends StatefulWidget {
  final String dietConstructor;

  const DietInformationPage({super.key, required this.dietConstructor});

  @override
  State<DietInformationPage> createState() => _DietInformationPageState();
}

class _DietInformationPageState extends State<DietInformationPage> {
  late String _dietConstructor;
  String currentDiet = "";
  Future<String> getCurrentDiet(String uid) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    currentDiet = document.get('currentDiet');
    return currentDiet;
  }

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    _dietConstructor = widget.dietConstructor;
    getCurrentDiet(uid!).then((String value) {
      setState(() {
        currentDiet = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite(String selectedDiet, String currentDiet) {
      if (selectedDiet == currentDiet) {
        return true;
      } else {
        return false;
      }
    }

    bool isIconSelected = isFavorite(_dietConstructor, currentDiet);

    return MaterialApp(
      title: "Diet App",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Diet App"),
          backgroundColor: const Color.fromRGBO(147, 129, 255, 1),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 12, child: titleMedium(_dietConstructor)),
                      Expanded(
                          flex: 2,
                          child: IconButton(
                              color: isIconSelected ? getOrange() : Colors.black45,
                              splashRadius: 30,
                              onPressed: () {
                                final User? user = FirebaseAuth.instance.currentUser;
                                String? uid = user?.uid;
                                if (_dietConstructor != currentDiet){
                                  setState(() {
                                    currentDiet = _dietConstructor;
                                  });
                                  FirebaseFirestore.instance.collection('users').doc(uid).update({'currentDiet': _dietConstructor});
                                  FirebaseFirestore.instance
                                      .collection('diets')
                                      .doc(_dietConstructor)
                                      .get()
                                      .then((DocumentSnapshot documentSnapshot) {
                                    if (documentSnapshot.exists) {
                                      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                      String imageUrl = data['imageurl'];
                                      FirebaseFirestore.instance.collection('users').doc(uid).update({'currentdieturl': imageUrl});
                                    }
                                  });
                                  flushbarSelectDiet(context, _dietConstructor);
                                }
                                else{
                                  setState(() {
                                    currentDiet = "null";
                                    FirebaseFirestore.instance.collection('users').doc(uid).update({'currentDiet': 'null'});
                                    FirebaseFirestore.instance.collection('users').doc(uid).update({'currentdieturl': 'null'});
                                  });
                                  flushbarUnselectDiet(context, _dietConstructor);
                                }
                              },
                              icon: const Tooltip(message: "Press this to select your current diet", child: Icon(Icons.play_arrow_outlined,)), iconSize: 32,)),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  // Diet Description Firebase'den buraya gelecek

                  Column(
                    children: [
                      //Buradaki streambuilder diyet hakkında bilgi veren texti oluşturur.
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('diets')
                            .doc(_dietConstructor)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot asyncSnapshot) {
                          if (!asyncSnapshot.hasData ||
                              asyncSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade500,
                              highlightColor: Colors.grey.shade300,
                              period: const Duration(milliseconds: 1500),
                              child: dietInformationText(" ", context),
                            );
                          }
                          return titleDescription(
                              asyncSnapshot.data['dietinfo']);
                        },
                      )
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  //Kullanıcının alacağı kalori sayısını ve diyet'in kullanıcıya olan etkilerini göstermek için bir row açılıyor.

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  //List tile sayesinde diyetin kalorisini vs. göstermek için bir ListTileTheme oluşturuluyor.

                  ListTileTheme(
                    contentPadding: const EdgeInsets.all(0),
                    child: Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        textColor: const Color.fromRGBO(0, 0, 0, 1.0),
                        iconColor: Colors.black,
                        title: Text(
                          "Diet Information",
                          style: GoogleFonts.ptSans(fontSize: 24),
                        ),
                        children: [
                          Column(
                            children: [
                              Row(children: [
                                Expanded(
                                    child: dietInformationText(
                                        "Diet Type:", context)),
                                Expanded(
                                    child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('diets')
                                      .doc(_dietConstructor)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot asyncSnapshot) {
                                    if (!asyncSnapshot.hasData ||
                                        asyncSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade500,
                                        highlightColor: Colors.grey.shade300,
                                        period:
                                            const Duration(milliseconds: 1500),
                                        child:
                                            dietInformationText(" ", context),
                                      );
                                    }
                                    return dietInformationText2(
                                      asyncSnapshot.data['diettype'],
                                      context,
                                    );
                                  },
                                ))
                              ]),
                              Row(
                                children: [
                                  Expanded(
                                      child: dietInformationText(
                                          "Daily Calorie Intake:", context)),
                                  Expanded(
                                      child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('diets')
                                        .doc(_dietConstructor)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot asyncSnapshot) {
                                      if (!asyncSnapshot.hasData ||
                                          asyncSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey.shade500,
                                          highlightColor: Colors.grey.shade300,
                                          period: const Duration(
                                              milliseconds: 1500),
                                          child: dietInformationText2(
                                              " ", context),
                                        );
                                      }
                                      return dietInformationDatabaseText(
                                          asyncSnapshot
                                              .data['dailycalorieintake'],
                                          context,
                                          "cal");
                                    },
                                  ))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  //Diet Günleri Bir ListView kullanarak aşağıda sıralanacak. Ayrıca içindeki yiyecekler de basıldığı zaman gözükecek.

                  SingleChildScrollView(
                    //Buradaki streambuilder sayesinde diyette bulunan günlerin tümünü tek tek listview sayesinde yazdırıyoruz.
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('diets')
                              .doc(_dietConstructor)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final dayLength = snapshot.data!['days'];
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dayLength,
                              itemBuilder: (context, index) {
                                int indexArttir = index + 1;
                                String currentDay = "Diet Day $indexArttir";
                                return Column(
                                  children: [
                                    const Divider(thickness: 1),
                                    TextButton(
                                      style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(
                                              getLila().withOpacity(0.2)),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                  top: 5,
                                                  bottom: 5))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DietDayInformationPage(
                                                        dietName: _dietConstructor,
                                                        dietDay: currentDay)));
                                      },
                                      child: ListTile(
                                          contentPadding: const EdgeInsets.all(0),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                currentDay,
                                                style: GoogleFonts.ptSans(
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.025),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                          })),
                ],
              ),
            )),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'diet_information_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleMedium("Explore New Diets"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // Bu streambuilder kullanıcılara diyetler hakkında veri gönderecektir. İlk olarak bir listview var ve bu listview document lengthi kadar veri alır.
            StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('diets').snapshots(),
              builder: (context, diets) {
                if (diets.hasData) {
                  return ListView.builder(
                    reverse: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: diets.data?.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot dietNumber = diets.data!.docs[index];

                      final firebaseStorageRef = FirebaseStorage.instance
                          .ref()
                          .child('diets/${dietNumber['imageurl']}.jpg');
                      return FutureBuilder( //Burada listview verilerine göre alacağımız diyet fotoğrafını firestore'dan çekme kodları çalışır.
                        future: firebaseStorageRef.getDownloadURL(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> urlSnapshot) {
                          if (urlSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade500,
                              highlightColor: Colors.grey.shade300,
                              period: const Duration(milliseconds: 1500),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                ],
                              ),
                            );
                          }
                          if (urlSnapshot.hasError) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade500,
                              highlightColor: Colors.grey.shade300,
                              period: const Duration(milliseconds: 1500),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Column( //Burada kullanıcıların gördüğü diyet ismi ve banner bulunur.
                            children: [
                              Container(
                                height:
                                MediaQuery.of(context).size.height * 0.14,
                                decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(urlSnapshot.data!),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black12.withOpacity(0.3),
                                          BlendMode.darken)),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: (){
                                    String constructor = dietNumber["dietname"];
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DietInformationPage(dietConstructor: constructor,)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width * 0.04),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          dietNumber["dietname"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.015,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else { //Burada ise kullanıcıların veri alamaması halinde bir shimmer döndüren kodu bulunur.
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade500,
                    highlightColor: Colors.grey.shade300,
                    period: const Duration(milliseconds: 1500),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height *
                              0.14,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.circular(10)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.015,
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Services/Widgets.dart';
import 'diet_information_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    final currentUserRef = usersRef.doc(uid);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: currentUserRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncsnapshot) {
                String currentHourString =
                    DateFormat('HH').format(DateTime.now());
                int currentHour = int.parse(currentHourString);
                if (!asyncsnapshot.hasData) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade500,
                    highlightColor: Colors.grey.shade300,
                    period: const Duration(milliseconds: 1500),
                    child: textHeadline(" ", " "),
                  );
                }
                if (currentHour >= 00 && currentHour <= 06) {
                  return textHeadline(
                      'Good Night, ', '${asyncsnapshot.data['name']}');
                } else if (currentHour >= 07 && currentHour <= 11) {
                  return textHeadline(
                      'Good Morning, ', '${asyncsnapshot.data['name']}');
                } else if (currentHour >= 12 && currentHour <= 14) {
                  return textHeadline(
                      'Good Afternoon, ', '${asyncsnapshot.data['name']}');
                } else if (currentHour >= 15 && currentHour <= 18) {
                  return textHeadline(
                      'Good Day, ', '${asyncsnapshot.data['name']}');
                } else {
                  return textHeadline(
                      'Good Evening, ', '${asyncsnapshot.data['name']}');
                }
              },
            ), // Kullanıcıyı Karşılayacak mesajı gösteren streambuilder. Burada kullanıcının ismini ve zamanı alarak kullanıcıya mesaj gösterilir.
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              "Your Current Diet",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            //Kullanıcının o anda yaptığı diyeti gösteren streambuilder.
            StreamBuilder<DocumentSnapshot>(
              stream: currentUserRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncsnapshot) {
                if (!asyncsnapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (asyncsnapshot.data["currentDiet"] == "null") {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(185, 255, 185, 1.0),
                          Color.fromRGBO(193, 255, 142, 1.0),
                        ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "You don't have a selected diet.",
                            style: GoogleFonts.heebo(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  final firebaseStorageRef = FirebaseStorage.instance
                      .ref()
                      .child('diets/${asyncsnapshot.data['currentdieturl']}.jpg');
                  return  FutureBuilder(
                    future: firebaseStorageRef.getDownloadURL(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> urlSnapshot) {
                      if (urlSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade500,
                          highlightColor: Colors.grey.shade300,
                          period: const Duration(milliseconds: 1500),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        );
                      }
                      if (urlSnapshot.hasError) {
                        return const Text(
                            'An error occurred while downloading the image.');
                      }
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: (){
                          String constructor = asyncsnapshot.data['currentDiet'];
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DietInformationPage(dietConstructor: constructor,)));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(urlSnapshot.data!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black12.withOpacity(0.35),
                                    BlendMode.darken)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  asyncsnapshot.data["currentDiet"],
                                  style: GoogleFonts.heebo(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            const Divider(thickness: 1,),
            titleMedium("Body Information"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            StreamBuilder<DocumentSnapshot>( // Kullanıcının kitle boy endeksini hesaplayan ve kullanıcıya vücut bilgisini gösteren streambuilder
              stream: currentUserRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
                if (!asyncSnapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                else{
                  String userBmi = "";

                  if(asyncSnapshot.data['bmi'] >= 20 && asyncSnapshot.data['bmi'] <=25){
                    userBmi = "Healthy";
                  }
                  else if(asyncSnapshot.data['bmi'] >= 26 && asyncSnapshot.data['bmi'] <=30){
                    userBmi = "Overweight";
                  }
                  else if(asyncSnapshot.data['bmi'] >= 31 && asyncSnapshot.data['bmi'] <=40){
                    userBmi = "Obese";
                  }
                  else if(asyncSnapshot.data['bmi'] >= 41){
                    userBmi = "Very Obese";
                  }
                  else{
                    userBmi = "Underweight";
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Height", style: GoogleFonts.poppins(fontSize: 20, color: Colors.black45, fontWeight: FontWeight.w500)),
                          Text("${asyncSnapshot.data['height'] * 100} Cm", style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Weight", style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                          Text("${asyncSnapshot.data['weight']} Kg", style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("BMI", style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                          Text(userBmi, style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: currentUserRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
                if (!asyncSnapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Water Intake", style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("${asyncSnapshot.data['weight'] * 30} ml per day", style: GoogleFonts.poppins(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            const Divider(thickness: 1,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            titleMedium("Weight History"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            //Kullanıcının kilosunun geçmişini tutan grafiği oluşturan streambuilder.
            StreamBuilder<DocumentSnapshot>(
              stream: currentUserRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
                if (!asyncSnapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List kiloArray = asyncSnapshot.data['weight_history'];
                List <FlSpot> data = [];
                for (int i = 0; i < kiloArray.length; i++) {
                  int weight = kiloArray[i];
                  data.add(FlSpot(i.toDouble(), weight.toDouble()));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: LineChart(
                          LineChartData(

                            lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: getOrange(),
                                  getTooltipItems: (touchedSpots){
                                    return touchedSpots.map((LineBarSpot spot) {
                                      return LineTooltipItem(
                                        '${spot.y.toInt()} kg',
                                        const TextStyle(color: Colors.white),
                                      );
                                    }).toList();
                                  },
                                )
                            ),
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false
                                  )
                              ),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false
                                  )
                              ),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false
                                  )
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false
                                  )
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: data,
                                isCurved: true,
                                color: getOrange(),
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                                curveSmoothness: 0.0,
                                barWidth: 3
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


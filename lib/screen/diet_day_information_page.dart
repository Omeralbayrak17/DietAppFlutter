import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:diet_app/screen/diet_information_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DietDayInformationPage extends StatefulWidget {
  String dietName;
  String dietDay;

  DietDayInformationPage({required this.dietName, required this.dietDay});

  @override
  State<DietDayInformationPage> createState() => _DietDayInformationPageState();
}

class _DietDayInformationPageState extends State<DietDayInformationPage> {
  late String _dietDay;
  late String _dietName;
  int userBmi = 1;

  @override
  void initState() {
    super.initState();
    _dietDay = widget.dietDay;
    _dietName = widget.dietName;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((documentSnapshot) {
      setState(() {
        userBmi = documentSnapshot.data()!['bmi'];
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Diet App',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(_dietDay),
            backgroundColor: getLila(),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Bu streambuilder sayesinde kullanıcının seçtiği diyetin günlük yemek bilgisi gösterilir.
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('diets').doc(_dietName).collection(_dietDay).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text('Bir hata oluştu: ${snapshot.error}');
              }
              final subcollectionDocs = snapshot.data?.docs;
              //Buradaki listview sayesinde günlük yemek sayısını collection sayısı ile eşitlenir.
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: subcollectionDocs?.length,
                itemBuilder: (context, index) {
                  final doc = subcollectionDocs![index];
                  return ListTile(
                    //Bu list tile ile üstte açıklanan collectionların hepsinin documentleri tek tek çekilir ve kullanıcıya gösterilir.
                    title: titleMedium(doc.id),
                    subtitle: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: doc.reference.snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> subSnapshot) {
                        if (!subSnapshot.hasData) {
                          return const Text('Loading...');
                        }
                        if (subSnapshot.hasError) {
                          return Text('Bir hata oluştu: ${subSnapshot.error}');
                        }
                        final subDocData = subSnapshot.data?.data();
                        int? subDocLength = subDocData?.length;
                        subDocLength = (subDocLength! ~/ 2);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(thickness: 1,),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: subDocLength + 1,
                              itemBuilder: (context, index) {
                                if (index == 0){
                                  return const SizedBox.shrink();
                                }
                                String foodName = subSnapshot.data?.data()?["food$index"];
                                double foodCalorie = subSnapshot.data?.data()?["foodcal$index".toString()].toDouble() ?? 0.0;
                                //Burada kullanıcının kitle boy endeksi baz alınarak ne kadar yemek yemesi gerekiyor hesaplanılır ve bu sayede kullanıcıya ortalama bir kalori gösterilir.
                                if (userBmi <= 18){
                                  int userCal = ((userBmi / 10) * foodCalorie).round();
                                  String finalCalorie = "$userCal cal";
                                  return Row(
                                    children: [
                                      Expanded(child: Text(foodName, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.left,)),
                                      Expanded(child: Text(finalCalorie.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.right,)),
                                    ],
                                  );
                                }
                                else if (userBmi >= 19 && userBmi <= 25){
                                  int userCal = ((userBmi / 20) * foodCalorie).round();
                                  String finalCalorie = "$userCal cal";
                                  return Row(
                                    children: [
                                      Expanded(child: Text(foodName, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.left,)),
                                      Expanded(child: Text(finalCalorie.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.right,)),
                                    ],
                                  );
                                }
                                else if(userBmi >=26 && userBmi <= 30){
                                  int userCal = ((userBmi / 25) * foodCalorie).round();
                                  String finalCalorie = "$userCal cal";
                                  return Row(
                                    children: [
                                      Expanded(child: Text(foodName, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.left,)),
                                      Expanded(child: Text(finalCalorie.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.right,)),
                                    ],
                                  );
                                }
                                else{
                                  int userCal = ((userBmi / 25) * foodCalorie).round();
                                  String finalCalorie = "$userCal cal";
                                  return Row(
                                    children: [
                                      Expanded(child: Text(foodName, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.left,)),
                                      Expanded(child: Text(finalCalorie.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021, color: const Color.fromRGBO(98, 98, 98, 1.0)), textAlign: TextAlign.right,)),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
            )
              ],
            ),
          ),
        )
    );
  }
}

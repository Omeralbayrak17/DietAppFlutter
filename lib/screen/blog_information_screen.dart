import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class BlogInformationScreen extends StatefulWidget {

  final String blogConstructor;
  final String blogID;
  const BlogInformationScreen({super.key, required this.blogConstructor, required this.blogID});

  @override
  State<BlogInformationScreen> createState() => _BlogInformationScreenState();
}

class _BlogInformationScreenState extends State<BlogInformationScreen> {

  late String blogConstructor;
  late String blogID;

  @override
  void initState(){
    super.initState();
    blogConstructor = widget.blogConstructor;
    blogID = widget.blogID;
  }
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                //Buradaki futurebuilder sayesinde blog'un fotoğrafını firestoredan alınır ve gösterilir.
                FutureBuilder(
                  future: FirebaseStorage.instance.ref().child('blogs/$blogID.jpg').getDownloadURL(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade500,
                        highlightColor: Colors.grey.shade300,
                        period: const Duration(milliseconds: 1500),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot.data!),
                          ),
                        ),
                      );
                    }
                  },
                ),
                //Bu padding ile fotoğraftan sonraki alanlara boşluk bırakılınır.
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      titleMedium(blogConstructor), //Bloğun başlığı burada gösterilir.
                      //Bu streambuilder sayesinde database'a erişim sağlanır ve blog içeriği çekilir. replaceAll metodu ile \n gözüken yerlerde birer satır atlanılır.
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('blogs').doc(blogID).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot asyncsnapshot) {
                          if(!asyncsnapshot.hasData){
                            return const CircularProgressIndicator();
                          }

                          return Wrap(children: [Text(asyncsnapshot.data["blog_desc"].replaceAll('\\n',  '\n'), style: GoogleFonts.heebo(fontWeight: FontWeight.w400, color: Color.fromRGBO(50, 50, 50, 1), fontSize: 16),)]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

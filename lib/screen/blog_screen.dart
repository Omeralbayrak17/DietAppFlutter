import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Services/Widgets.dart';
import 'package:diet_app/screen/blog_information_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'diet_information_page.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
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
            titleMedium("Monthly Recommended Blog"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            //Buradaki streambuilder sayesinde aynı explore ekranında olduğu gibi blogs database'ine erişip bir listview ile kullanıcıların görebileceği şekilde blogları listeliyoruz.
            StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('blogs').where('blog_name', isEqualTo: 'How To Cook Pizza').snapshots(),
              builder: (context, blogs) {
                if (blogs.hasData) {
                  return ListView.builder(
                    reverse: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: blogs.data?.docs.length, //Buradaki itemcount blogs collectionunun içindeki document sayısı kadar olur bu sayede listview olması gerektiği kadar döner.
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot blogNumber = blogs.data!.docs[index];
                      final firebaseStorageRef = FirebaseStorage.instance
                          .ref()
                          .child('blogs/${blogNumber['blog_url']}.jpg'); // Buradaki kod sayesinde firestore'a erişip fotoğrafı gösteriyoruz kullanıcıya
                      return FutureBuilder(
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
                          return Column( // Bu kod sayesinde kullanıcılara bir container döndürüyoruz ve banner şekilde kullanıcılara gösteriyoruz.
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
                                    String constructor = blogNumber["blog_name"];
                                    String blogID = blogNumber["blog_id"];
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context, Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return BlogInformationScreen(blogConstructor: constructor, blogID: blogID);
                                        },
                                        transitionsBuilder: (BuildContext context, Animation<double> animation,
                                            Animation<double> secondaryAnimation, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
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
                                          blogNumber["blog_name"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Written by: " + blogNumber["blog_author"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
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
                } else {
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
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            titleMedium("Diet Blogs"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('blogs').where('blog_type', isEqualTo: 'Diet').snapshots(),
              builder: (context, blogs) {
                if (blogs.hasData) {
                  return ListView.builder(
                    reverse: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: blogs.data?.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot blogNumber = blogs.data!.docs[index];
                      final firebaseStorageRef = FirebaseStorage.instance
                          .ref()
                          .child('blogs/${blogNumber['blog_url']}.jpg');
                      return FutureBuilder(
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
                          return Column(
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
                                          Colors.black12.withOpacity(0.4),
                                          BlendMode.darken)),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: (){
                                    String constructor = blogNumber["blog_name"];
                                    String blogID = blogNumber["blog_id"];
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context, Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return BlogInformationScreen(blogConstructor: constructor, blogID: blogID);
                                        },
                                        transitionsBuilder: (BuildContext context, Animation<double> animation,
                                            Animation<double> secondaryAnimation, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
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
                                          blogNumber["blog_name"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Written by: " + blogNumber["blog_author"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
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
                } else {
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
            ),
            titleMedium("Cooking Blogs"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('blogs').where('blog_type', isEqualTo: 'Cooking').snapshots(),
              builder: (context, blogs) {
                if (blogs.hasData) {
                  return ListView.builder(
                    reverse: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: blogs.data?.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot blogNumber = blogs.data!.docs[index];
                      final firebaseStorageRef = FirebaseStorage.instance
                          .ref()
                          .child('blogs/${blogNumber['blog_url']}.jpg');
                      return FutureBuilder(
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
                          return Column(
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
                                    String constructor = blogNumber["blog_name"];
                                    String blogID = blogNumber["blog_id"];
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context, Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return BlogInformationScreen(blogConstructor: constructor, blogID: blogID);
                                        },
                                        transitionsBuilder: (BuildContext context, Animation<double> animation,
                                            Animation<double> secondaryAnimation, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
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
                                          blogNumber["blog_name"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Written by: " + blogNumber["blog_author"],
                                          style: GoogleFonts.heebo(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
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
                } else {
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
            ),
          ],
        ),
      ),
    );;
  }
}

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:back/homescreen1.dart';
import 'package:back/newvideo.dart';
//import 'package:ravi/usermodel.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class MyOptions extends StatefulWidget {
  @override
  _MyOptionsState createState() => _MyOptionsState();
}

class _MyOptionsState extends State<MyOptions> {
  // var name = "";
  // @override
  // User? user = FirebaseAuth.instance.currentUser;
  // UserModel loggedInUser = UserModel();
  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     this.loggedInUser = UserModel.fromMap(value.data());
  //     name = "${loggedInUser.Name}";
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Brain Hemorrhage Classifier',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E232C),
          title: Text('Brain Hemorrhage Classifier'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 20,
                //   ),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.8,
                //     child: Text(
                //       'Hello $name',
                //       style: TextStyle(
                //           fontSize: 25,
                //           fontWeight: FontWeight.w500,
                //           color: Color(0xFF1E232C)),
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      "Select an Image or Video",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E232C)),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //login button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          color: const Color(0xFF1E232C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHome()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Image",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //register button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color(0xFF1E232C),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHome1()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Video",
                              style: TextStyle(
                                color: Color(0xFF1E232C),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

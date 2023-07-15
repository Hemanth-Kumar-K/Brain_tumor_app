import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:back/usermodel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({super.key});

  static String verify = "";
  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  @override
  TextEditingController countrycode = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  var phone = "";
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
    countrycode.text = "+91";

    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      phonenumber.text = "${loggedInUser.phonenumber}";
      phone = "${loggedInUser.phonenumber}";
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
            // margin: EdgeInsets.only(left: 25, right: 25),
            // alignment: Alignment.center,
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "We need to register your phone before getting started!",
                  style: TextStyle(
                    color: Color(0xFF8391A1),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F9),
                    border: Border.all(
                      color: const Color(0xFFE8ECF4),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: TextFormField(
                      controller: phonenumber,
                      onChanged: (value) => {phone = value},
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(
                          color: Color(0xFF8391A1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // SizedBox(
              //     child: ElevatedButton(
              //   onPressed: () async {
              //     await FirebaseAuth.instance.verifyPhoneNumber(
              //       phoneNumber: '${countrycode.text + phone}',
              //       verificationCompleted: (PhoneAuthCredential credential) {},
              //       verificationFailed: (FirebaseAuthException e) {},
              //       codeSent: (String verificationId, int? resendToken) {
              //         MyPhone.verify = verificationId;
              //         Navigator.pushNamed(context, "otp");
              //       },
              //       codeAutoRetrievalTimeout: (String verificationId) {},
              //     );

              //     // Navigator.pushNamed(context, "otp");
              //   },
              //   child: const Padding(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 20,
              //       vertical: 5,
              //     ),
              //     child: Text(
              //       "Send the Code",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //       primary: const Color(0xFF1E232C),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8))),
              // ))
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
                        onPressed: () async {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '${countrycode.text + phone}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              MyPhone.verify = verificationId;

                              Navigator.pushNamed(context, 'otp1');
                              Fluttertoast.showToast(
                                  msg: "OTP Sent Successfully");
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Send the Code",
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
            ],
          ),
        )));
  }
}

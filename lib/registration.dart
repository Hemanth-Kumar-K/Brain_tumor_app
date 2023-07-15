import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:back/login.dart';
import 'package:back/usermodel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final NameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();
  final phonenumberEditingController = new TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordFocusNode1 = FocusNode();

  var is_obsure;
  var is_obsure_1;
  @override
  void initState() {
    super.initState();
    is_obsure = true;
    is_obsure_1 = true;
  }

  @override
  Widget build(BuildContext context) {
    String email = '', pass = '';

    //FirstName Field
    final firstnameField = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
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
                  autofocus: false,
                  controller: NameEditingController,
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("Name cannot be Empty");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please enter valid Name(Min 3 Character)");
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                  ),
                  onSaved: (value) {
                    NameEditingController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final emailField = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
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
                  autofocus: false,
                  onChanged: (value) => {email = value},
                  controller: emailEditingController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                  ),
                  onSaved: (value) {
                    emailEditingController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final phoneField = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
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
                  autofocus: false,
                  //onChanged: (value) => {email = value},
                  controller: phonenumberEditingController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Phone Number");
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                  ),
                  onSaved: (value) {
                    phonenumberEditingController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final passwordField = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF7F8F9),
                border: Border.all(
                  color: const Color(0xFFE8ECF4),
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: TextFormField(
                autofocus: false,
                obscureText: is_obsure,
                controller: passwordEditingController,
                focusNode: passwordFocusNode,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Password is required for login");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Please enter valid Password(Min 6 Character)");
                  }
                },
                onSaved: (value) {
                  passwordEditingController.text = value!;
                },
                textInputAction: TextInputAction.done,
                onChanged: (value) => {pass = value},
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                    suffixIcon: IconButton(
                      icon: is_obsure
                          ? const Icon(
                              Icons.visibility,
                              color: Color(0xFF8391A1),
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF8391A1),
                            ),
                      onPressed: () {
                        setState(() {
                          is_obsure = !is_obsure;
                        });
                      },
                    )),
              ),
            ),
          ),
        ),
      ],
    ));

    final confirmPasswordField = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF7F8F9),
                border: Border.all(
                  color: const Color(0xFFE8ECF4),
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: TextFormField(
                autofocus: false,
                obscureText: is_obsure_1,
                controller: confirmpasswordEditingController,
                focusNode: passwordFocusNode1,
                validator: (value) {
                  if (confirmpasswordEditingController.text !=
                      passwordEditingController.text) {
                    return "Password don't match";
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmpasswordEditingController.text = value!;
                },
                textInputAction: TextInputAction.done,
                onChanged: (value) => {pass = value},
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                    suffixIcon: IconButton(
                      icon: is_obsure_1
                          ? const Icon(
                              Icons.visibility,
                              color: Color(0xFF8391A1),
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF8391A1),
                            ),
                      onPressed: () {
                        setState(() {
                          is_obsure_1 = !is_obsure_1;
                        });
                      },
                    )),
              ),
            ),
          ),
        ),
      ],
    ));

    //SignUp Button
    final SignUpButton = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
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
                    SignUp(emailEditingController.text,
                        passwordEditingController.text);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Register",
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
        )
      ],
    ));
    final heading = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.0,
            child: const Text(
              "Hello! Register to get started",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    heading,
                    firstnameField,
                    emailField,
                    phoneField,
                    passwordField,
                    confirmPasswordField,
                    SignUpButton,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'login');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF35C2C1),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void SignUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFireStore(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        Navigator.pushNamed(context, 'login');
      });
    }
  }

  postDetailsToFireStore() async {
    //Calling our firestore
    //calling our user model
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user!.uid;
    userModel.phonenumber = phonenumberEditingController.text;
    userModel.Name = NameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created successfully");
    /* Navigator.pushAndRemoveUntil(
        context,
       // MaterialPageRoute(builder: (context) => HomeScreen()),
        //(route) => false); */
    Navigator.pushNamed(context, 'login');
  }
}
